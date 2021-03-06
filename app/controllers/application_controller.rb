class ApplicationController < ActionController::Base
    include SiteMastersHelper
    include UsersHelper
    
    protect_from_forgery with: :exception
    before_action :set_locale
    around_action :set_current_user
    
    def set_current_user
        UsersHelper::Current.user = current_user
        yield
    ensure
        UsersHelper::Current.user = nil
    end
    
    def set_locale
        I18n.locale = params[:locale] || :en
    end

    def my_published_fandoms
        @my_published_fandoms = current_user.fandoms.published if user_signed_in?
        @user = UsersHelper::Current.user
    end
    
    def set_for_fandom_show_template_data
        redirect_to root_path unless @fandom.published
    
        @links = @fandom.links.order(created_at: :desc).first(30)
        @my_fandom = user_signed_in? ? current_user.myfandoms.where(fandom_id: @fandom.id) : []
    
        # 팔로우 버튼 토글 전용 키값 해시 데이터
        @follow_control = { follow_cmd: '', myfandom_id: 0, channel_id: '', user_id: '' }

        # Tab Group for each planet view
        @tabs = []
        @tabs << { name: 'wiki', path: "/fandoms/#{@fandom.id}/wikis", active: '' }
        @tabs << { name: 'history', path: "/fandoms/#{@fandom.id}/histories", active: '' }
        @tabs << { name: 'library', path: "/fandoms/#{@fandom.id}", active: '' }
        @tabs << { name: 'schedule', path: "/fandoms/#{@fandom.id}/schedules", active: '' }
    end
end
