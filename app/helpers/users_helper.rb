module UsersHelper
    
    def get_current_user_id
        user_id = 0
        if user_signed_in?
            user_id = current_user.id
        end
        return user_id
    end
    
end