class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    
    def config_update_publish_limit
        3
    end
end
