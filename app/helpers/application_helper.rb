module ApplicationHelper
    def app_title
        'HereFan'
    end
    
    def now
        DateTime.now
    end
    
    def skip_include_controllers
        %w(users/registrations users/sessions fandoms links)
    end
end
