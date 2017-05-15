module ApplicationHelper
    def app_title
        'HereFan'
    end
    
    def app_description
        'The fastest way to k-dol stars, HereFan'
    end
    
    def app_domain
        'http://test.herefan.com'
    end
    
    def app_fandom
        'Planet'
        # 'Cloud'
        # 'Stream'
        # 'Wave'
    end
    
    def app_config
        app_config_info = {}

        if @fandom
            app_config_info[:title]         = "#{@fandom.name} with #{app_title}"
            app_config_info[:description]   = "Welcome to #{@fandom.name} #{app_fandom}!!"
            app_config_info[:url]           = "#{app_domain}/fandoms/#{@fandom.id}"
            app_config_info[:image]         = "#{@fandom.profile_img}"
        end
        app_config_info[:title]         ||= app_title
        app_config_info[:description]   ||= app_description
        app_config_info[:url]           ||= app_domain
        app_config_info[:image]         ||= app_domain + '/svg/facebook_send.png'
        
        return app_config_info
    end
    
    def now
        DateTime.now
    end
    
    def skip_include_controllers
        %w(users/sessions links)
    end
    
    def image_with_sns(img_path)
        is_contain = false
        return default_profile_img if img_path.include? default_profile_img
        
        split = img_path.split('%3A//')
        path        = split.last
        protocol    = split.first.split('/').last
        
        sns_asset_domains.each do |domain|
            is_contain = true if path.include? domain
        end
        
        return is_contain ? protocol + path : img_path
    end
    
    def default_profile_img
        '/img/default-user-image.png'
    end
    
    def sns_asset_domains
        %w(graph.facebook.com pbs.twimg.com lh3.googleusercontent.com)
    end
end