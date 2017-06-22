class FandomsController < ApplicationController
    include FandomsHelper
    before_action :set_fandom, only: [:show, :edit, :update, :destroy]
    before_action :my_published_fandoms
    
    # GET /fandoms
    # GET /fandoms.json
    def index
        method = params[:method] ? params[:method] : 'popular'
        
        case method
        when 'popular'
            @fandoms = Fandom.published.all.sort_by { |fandom| 0 - fandom.myfandoms.count }
            @fandoms_not_active = Fandom.unpublished.all.sort_by { |fandom| 0 - fandom.myfandoms.count }
            
        when 'recent'
            @fandoms = Fandom.published.order(created_at: :desc).to_a
            @fandoms_not_active = Fandom.unpublished.order(created_at: :desc).to_a
            
        when 'abc'
            @fandoms = Fandom.published.all.sort { |a, b| a.config.fd_name <=> b.config.fd_name }
            @fandoms_not_active = Fandom.unpublished.all.sort { |a, b| a.config.fd_name <=> b.config.fd_name }
        end
        
        
        @my_fandoms = current_user.fandoms.published.ids if user_signed_in?
    end
    
    # GET /fandoms/1
    # GET /fandoms/1.json
    def show
        set_for_fandom_show_template_data
        @tabs[2][:active] = 'active'

        if user_signed_in?
            @follow_control[:follow_cmd]    = is_my_fandom?(user: current_user, fandom: @fandom) ? 'cancel' : 'follow'
            @follow_control[:myfandom_id]   = @my_fandom.take.nil? ? 0 : @my_fandom.take.id
            @follow_control[:channel_id]    = @fandom.id
            @follow_control[:user_id]       = current_user.id
        end
    end
    
    # GET /fandoms/new
    def new
        @fandom = Fandom.new
    end
    
    # GET /fandoms/1/edit
    def edit
    end
    
    # POST /fandoms
    # POST /fandoms.json
    def create
        @fandom = Fandom.new(fandom_params)
        
        respond_to do |format|
            if @fandom.save
                Myfandom.create(fandom: @fandom, user: current_user)
                format.html { redirect_to :back, notice: 'Fandom was successfully created.' }
                format.json { render :show, status: :created, location: @fandom }
            else
                format.html { render :new }
                format.json { render json: @fandom.errors, status: :unprocessable_entity }
            end
        end
    end
    
    # PATCH/PUT /fandoms/1
    # PATCH/PUT /fandoms/1.json
    def update
        respond_to do |format|
            if @fandom.update(fandom_params)
                format.html { redirect_to @fandom, notice: 'Fandom was successfully updated.' }
                format.json { render :show, status: :ok, location: @fandom }
            else
                format.html { render :edit }
                format.json { render json: @fandom.errors, status: :unprocessable_entity }
            end
        end
    end
    
    # DELETE /fandoms/1
    # DELETE /fandoms/1.json
    def destroy
        @fandom.destroy
        respond_to do |format|
            format.html { redirect_to fandoms_url, notice: 'Fandom was successfully destroyed.' }
            format.json { head :no_content }
        end
    end
    
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_fandom
        @fandom = Fandom.find(params[:id])
        @config = @fandom.configs.count.zero? ? make_fandom_config(@fandom) : @fandom.config
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def fandom_params
        params.require(:fandom).permit(:name, :profile_img, :background_img)
    end
end
