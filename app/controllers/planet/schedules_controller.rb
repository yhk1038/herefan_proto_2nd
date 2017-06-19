class Planet::SchedulesController < ApplicationController
    include FandomsHelper
    before_action :set_fandom
    before_action :set_schedule, only: [:show, :edit, :update, :destroy]
    before_action :inheritance_for_front_view
    before_action :my_published_fandoms
    
    def ready_for_schedule_dataset
        keys = [:title, :start, :end, :id, :className, :allDay]
        schedules = @fandom.schedules
        arr = []
    
        schedules.pluck(:title, :event_start, :event_end, :id, :class_name).each do |schedule|
            arr << schedule
        end
    
        arr = arr.map do |schedule|
            h = {}
            i = 0
            h[:allDay] = false
            schedule.each do |attr|
                h[keys[i]] = attr
                h[keys[i]] = '' unless attr
                
                if keys[i].to_s == 'className'
                    h[:allDay] = true if attr.include? 'allDay'
                    h[keys[i]] = attr.gsub('allDay','').split(' ').push('schedule').push('schedule-hf-'+h[:id].to_s).join(' ')
                end
                i += 1
            end
            h
        end
        
        return arr
    end
    
    # GET /fandoms/:fandom_id/schedules
    # GET /fandoms/:fandom_id/schedules.json
    def index
        @schedules = @fandom.schedules
        @schedules_for_js = ready_for_schedule_dataset
    end
    
    # GET /fandoms/:fandom_id/schedules/1
    # GET /fandoms/:fandom_id/schedules/1.json
    def show
        respond_to do |format|
            format.json { return render json: { data: @schedule, fandom: @schedule.fandom, status: :ok} }
        end
    end
    
    # GET /fandoms/:fandom_id/schedules/new
    def new
        @schedule = Schedule.new
    end
    
    # GET /fandoms/:fandom_id/schedules/1/edit
    def edit
    end
    
    # POST /fandoms/:fandom_id/schedules
    # POST /fandoms/:fandom_id/schedules.json
    def create
        @schedule = Schedule.new(schedule_params)
        
        respond_to do |format|
            if @schedule.save
                format.html { redirect_to @schedule, notice: 'Schedule was successfully created.' }
                # format.json { render :show, status: :created, location: @schedule }
                format.json { return render json: { data: @schedule, fandom: @schedule.fandom, status: :created} }
            else
                format.html { render :new }
                format.json { render json: @schedule.errors, status: :unprocessable_entity }
            end
        end
    end
    
    # PATCH/PUT /fandoms/:fandom_id/schedules/1
    # PATCH/PUT /fandoms/:fandom_id/schedules/1.json
    def update
        respond_to do |format|
            if @schedule.update(schedule_params)
                format.html { redirect_to @schedule, notice: 'Schedule was successfully updated.' }
                format.json { render :show, status: :ok, location: @schedule }
            else
                format.html { render :edit }
                format.json { render json: @schedule.errors, status: :unprocessable_entity }
            end
        end
    end
    
    # DELETE /fandoms/:fandom_id/schedules/1
    # DELETE /fandoms/:fandom_id/schedules/1.json
    def destroy
        @schedule.destroy
        respond_to do |format|
            format.html { redirect_to schedules_url, notice: 'Schedule was successfully destroyed.' }
            # format.json { head :no_content }
            format.json { return render json: { data: @schedule, status: 'deleted'} }
        end
    end
    
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
        @schedule = Schedule.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def schedule_params
        params.require(:schedule).permit(:fandom_id, :category, :title, :content, :event_start, :event_end, :url, :class_name, :description)
    end
    
    def inheritance_for_front_view
        set_for_fandom_show_template_data
        @tabs[3][:active] = 'active'
    
        if user_signed_in?
            @follow_control[:follow_cmd]    = is_my_fandom?(user: current_user, fandom: @fandom) ? 'cancel' : 'follow'
            @follow_control[:myfandom_id]   = @my_fandom.take.nil? ? 0 : @my_fandom.take.id
            @follow_control[:channel_id]    = @fandom.id
            @follow_control[:user_id]       = current_user.id
        end
    end
end