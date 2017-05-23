class Planet::HistoriesController < ApplicationController
    include FandomsHelper
    include HistoriesHelper
    before_action :set_fandom
    before_action :set_history, only: [:show, :edit, :update, :destroy]
    before_action :inheritance_for_front_view
    before_action :my_published_fandoms
    
    # GET /fandoms/:fandom_id/histories
    # GET /fandoms/:fandom_id/histories.json
    def index
        @histories = History.where(fandom_id: params[:fandom_id])
    end
    
    # GET /fandoms/:fandom_id/histories/1
    # GET /fandoms/:fandom_id/histories/1.json
    def show
    end
    
    # GET /fandoms/:fandom_id/histories/new
    def new
        @history = History.new
    end
    
    # GET /fandoms/:fandom_id/histories/1/edit
    def edit
    end
    
    # POST /fandoms/:fandom_id/histories
    # POST /fandoms/:fandom_id/histories.json
    def create
        @history = History.new(history_params)
        
        respond_to do |format|
            if @history.save
                format.html { redirect_to @history, notice: 'History was successfully created.' }
                format.json { render :show, status: :created, location: @history }
            else
                format.html { render :new }
                format.json { render json: @history.errors, status: :unprocessable_entity }
            end
        end
    end
    
    # PATCH/PUT /fandoms/:fandom_id/histories/1
    # PATCH/PUT /fandoms/:fandom_id/histories/1.json
    def update
        respond_to do |format|
            if @history.update(history_params)
                format.html { redirect_to @history, notice: 'History was successfully updated.' }
                format.json { render :show, status: :ok, location: @history }
            else
                format.html { render :edit }
                format.json { render json: @history.errors, status: :unprocessable_entity }
            end
        end
    end
    
    # DELETE /fandoms/:fandom_id/histories/1
    # DELETE /fandoms/:fandom_id/histories/1.json
    def destroy
        @history.destroy
        respond_to do |format|
            format.html { redirect_to histories_url, notice: 'History was successfully destroyed.' }
            format.json { head :no_content }
        end
    end
    
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_history
        @history = History.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def history_params
        params.require(:history).permit(:fandom_id, :user_id, :title, :event_date)
    end

    def inheritance_for_front_view
        set_for_fandom_show_template_data
        @tabs[1][:active] = 'active'
    
        if user_signed_in?
            @follow_control[:follow_cmd]    = is_my_fandom?(user: current_user, fandom: @fandom) ? 'cancel' : 'follow'
            @follow_control[:myfandom_id]   = @my_fandom.take.nil? ? 0 : @my_fandom.take.id
            @follow_control[:channel_id]    = @fandom.id
            @follow_control[:user_id]       = current_user.id
        end
    end
end
