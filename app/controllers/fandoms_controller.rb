class FandomsController < ApplicationController
    include FandomsHelper
    before_action :set_fandom, only: [:show, :edit, :update, :destroy]
    before_action :filling_tab_group, only: [:show]
    
    # GET /fandoms
    # GET /fandoms.json
    def index
        @fandoms = Fandom.all.sort_by { |fandom| 0 - fandom.myfandoms.count }
        @fandoms_not_active = Fandom.unpublished.all.sort_by { |fandom| 0 - fandom.myfandoms.count }
        @my_fandoms = current_user.fandoms.published.ids if user_signed_in?
    end
    
    # GET /fandoms/1
    # GET /fandoms/1.json
    def show
        redirect_to root_path unless @fandom.published
        
        @links = @fandom.links
        @my_fandom = user_signed_in? ? current_user.myfandoms.where(fandom_id: @fandom.id) : []
        
        # 팔로우 버튼 토글 전용 키값 해시 데이터
        @follow_control = { follow_cmd: '', myfandom_id: 0, channel_id: '', user_id: '' }
        if user_signed_in?
            @follow_control[:follow_cmd]    = is_my_fandom? ? 'cancel' : 'follow'
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
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def fandom_params
        params.require(:fandom).permit(:name, :profile_img, :background_img)
    end

    def filling_tab_group
        @tabs = []
        @tabs << { name: 'wiki', path: '', active: '' }
        @tabs << { name: 'history', path: '', active: '' }
        @tabs << { name: 'library', path: '', active: 'active' }
        @tabs << { name: 'schedule', path: '', active: '' }
    end
end
