module ApplicationHelper
    def app_title
        'HereFan'
    end
    
    def app_description
        'The fastest way to k-dol stars, HereFan'
    end
    
    def app_domain
        'http://13.124.91.0'
    end
    
    def app_config
        app_config_info = {}
        app_config_info[:title]         = app_title
        app_config_info[:description]   = app_description
        app_config_info[:url]           = app_domain
        app_config_info[:image]         = app_domain + '/svg/facebook_send.png'
        
        return app_config_info
    end
    
    def now
        DateTime.now
    end
    
    def skip_include_controllers
        %w(users/sessions links)
    end
end
