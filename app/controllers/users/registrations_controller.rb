class Users::RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]
    
    # GET /resource/sign_up
    # def new
    #   super
    # end
    
    # POST /resource
    # def create
    #   super
    # end
    
    # GET /resource/edit
    # def edit
    #     super
    # end
    
    # PUT /resource
    def update
        self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
        
        if resource.my_update_with_password(params[resource_name])
            if is_navigational_format?
                if resource.respond_to?(:pending_reconfirmation?) && resource.pending_reconfirmation?
                    flash_key = :update_needs_confirmation
                end
                set_flash_message :notice, flash_key || :updated
            end
            sign_in resource_name, resource, :bypass => true
            respond_with resource, :location => after_update_path_for(resource)
        else
            clean_up_passwords resource
        
            # collecting an errors and redirecting to the custom route
            flash[:error] = resource.errors.full_messages
            redirect_to edit_user_registration_path # => original: settings_path(current_user)
        end
    end
    
    # DELETE /resource
    def destroy
        # super
        if current_user.update(active: false)
            puts "\tDestroy Session! and Active Falsed!"
            redirect_to destroy_user_session_path
        else
            redirect_to :back
        end
    end
    
    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end
    
    protected
    
    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
        # devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end
    
    # If you have extra params to permit, append them to the sanitizer.
    def configure_account_update_params
        # devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
        @back_path = params[:back_path]
        devise_parameter_sanitizer.permit(:account_update, keys: [:name, :nickname, :birthday, :image])
    end
    
    # The path used after sign up.
    # def after_sign_up_path_for(resource)
    #   super(resource)
    # end
    
    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end

    # The path used after update.
    def after_update_path_for(resource)
        # super(resource)
        @back_path
    end
    
end
