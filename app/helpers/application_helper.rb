module ApplicationHelper
    include NavbarHelper    # 메인 네비게이션
    include UiToolkitHelper # Ui Toolkit
    include UsersHelper
    
    # 어플리케이션 메타정보
    # ==============================================================================================================================
    def app_title
        site_master.title
    end
    
    def app_description
        site_master.description
    end
    
    def app_domain
        site_master.url
    end
    
    def app_home
        site_master.home_name
    end
    
    def app_fandom
        site_master.fandom_name
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
        app_config_info[:image]         ||= app_domain + site_master.default_dummy_image
        
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
        site_master.default_profile_image
    end
    
    def sns_asset_domains
        %w(graph.facebook.com pbs.twimg.com lh3.googleusercontent.com)
    end
end