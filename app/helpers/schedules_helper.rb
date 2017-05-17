module SchedulesHelper
    
    def find_celandar_header_image(schedules)
        found = false
        schedules.order(event_start: :asc).each do |schedule|
            next if schedule.content.nil?
            # next if schedule.content
            found = schedule.content
        end
        found ? found : @fandom.background_img
    end
end
