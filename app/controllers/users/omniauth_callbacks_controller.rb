class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    before_action :set_user, only: [:twitter, :facebook, :google_oauth2]
    
    # You should configure your model like this:
    # devise :omniauthable, omniauth_providers: [:twitter]
    
    # You should also create an action method in this controller like this:
    def twitter
        if @user.persisted?
            if @user.active
                sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
                set_flash_message(:notice, :success, :kind => "Twitter") if is_navigational_format?
            else
                @user.update(active: true)
                sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
                set_flash_message(:notice, :success, :kind => "Twitter") if is_navigational_format?
            end
        else
            session["devise.twitter_data"] = request.env["omniauth.auth"]
            redirect_to new_user_registration_url
        end
    end

    def facebook
        # You need to implement the method below in your model (e.g. app/models/user.rb)
        if @user.persisted?
            if @user.active
                sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
                set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
            else
                @user.update(active: true)
                sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
                set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
            end
        else
            session["devise.facebook_data"] = request.env["omniauth.auth"]
            redirect_to new_user_registration_url
        end
    end

    def google_oauth2
        if @user.persisted?
            if @user.active
                sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
                set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
            else
                @user.update(active: true)
                sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
                set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
            end
        else
            session["devise.google_oauth2_data"] = request.env["omniauth.auth"]
            redirect_to new_user_registration_url
        end
    end
    
    def set_user
        @user = User.from_omniauth(request.env["omniauth.auth"])
    end

    def failure
        redirect_to root_path
    end
    
    
    # More info at:
    # https://github.com/plataformatec/devise#omniauth
    
    # GET|POST /resource/auth/twitter
    # def passthru
    #   super
    # end
    
    # GET|POST /users/auth/twitter/callback
    # def failure
    #   super
    # end
    
    # protected
    
    # The path used when OmniAuth fails
    # def after_omniauth_failure_path_for(scope)
    #   super(scope)
    # end
end
