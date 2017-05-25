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
        @histories = History.where(fandom_id: params[:fandom_id]).order(event_date: :desc)
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
        is_second_level = @history.fandom_id ? false : true

        saved = false
        if !is_second_level
            saved = @history.save # if History.where(event_date: @history.event_date).count.zero?
            message = "The History's Date (#{@history.event_date.strftime('%F')}) is already exist!" unless saved
        else
            @history.thumb_img = params[:history][:img]
            saved = @history.save if History.where(id: @history.history_id).count > 0
            message = "Sorry, History item not found!" unless saved
        end

        
        if saved
            if is_second_level
                redirect_to fandom_histories_path(params[:fandom_id])
            else
                return render '/planet/histories/create'
            end
        else
            return render json: { data: @history, status: :unprocessable_entity, message: message }
        end
    
        
        # respond_to do |format|
        #     if saved
        #         return render '/planet/histories/create'
        #         # format.html { redirect_to @history, notice: 'History was successfully created.' }
        #         # format.json { render :show, status: :created, location: @history }
        #         # upper = @history.fandom_id ? @history.fandom : @history.history
        #         # format.json { return render json: { data: @history, upper: upper, status: :created } }
        #     else
        #         # format.html { render :new }
        #         # format.json { render json: @history.errors, status: :unprocessable_entity }
        #         return render json: { data: @history, status: :unprocessable_entity, message: "The History's Date (#{@history.event_date.strftime('%F')}) is already exist!" }
        #     end
        # end
    end
    
    # PATCH/PUT /fandoms/:fandom_id/histories/1
    # PATCH/PUT /fandoms/:fandom_id/histories/1.json
    def update
        respond_to do |format|
            if @history.update(history_params)
                format.html { redirect_to @history, notice: 'History was successfully updated.' }
                # format.json { render :show, status: :ok, location: @history }
                upper = @history.fandom_id ? @history.fandom : @history.history
                format.json { return render json: { data: @history, upper: upper, status: :ok } }
            else
                format.html { render :edit }
                # format.json { render json: @history.errors, status: :unprocessable_entity }
                format.json { return render json: { data: @history, status: :unprocessable_entity, message: "The History's Date (#{@history.event_date.strftime('%F')}) is already exist!" } }
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
        params.require(:history).permit(:fandom_id, :user_id, :title, :event_date, :img, :thumb_img, :history_id)
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
