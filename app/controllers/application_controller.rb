class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :set_locale
    
    def config_update_publish_limit
        3
    end

    def set_locale
        I18n.locale = params[:locale] || :en
    end

    def my_published_fandoms
        @my_published_fandoms = current_user.fandoms.published if user_signed_in?
    end
end
