module UsersHelper
    module Current
        thread_mattr_accessor :user
    end
    
    def get_current_user_id
        user_id = 0
        if user_signed_in?
            user_id = current_user.id
        end
        return user_id
    end
    
    def valid_display_on_user_level(myfandom, script: nil)
        display = ''
        if script
            display = script
        end
        
        
        if UsersHelper::Current.user    # 로그인 했는가?
            if myfandom.nil?                # 팔로우 하지 않았다면?
                display = 'hey_follow();'
                display += ' return false;'
            end
        else                            # 로그인 하지 않았으면?
            # display = 'hey_login();'
            display = '$("#login_modal").modal();'
            display += ' return false;'
        end
        return display
    end
end