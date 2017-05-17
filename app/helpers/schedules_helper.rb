module SchedulesHelper
    
    def find_celandar_header_image(schedules)
        found = false
        schedules.order(event_end: :desc).each do |schedule|
            next if schedule.content.nil?
            found = schedule.content
        end
        found ? found : @fandom.background_img
    end
end
