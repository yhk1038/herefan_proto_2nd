module SiteMastersHelper
    
    
    def config_update_publish_limit
        site_master.fandom_publish_count
    end
    
    def site_master
        if @site_master.nil?
            @site_master = load_site_master
        end
        
        @site_master
    end
    
    def load_site_master
        SiteMaster.first_or_create
    end
end
