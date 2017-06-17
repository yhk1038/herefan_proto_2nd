class Backoffice::ConsoleController < ApplicationController
    before_action :check_login
    before_action :check_authorize
    
    before_action :set_fandom, only: [:setting_planet]
    
    layout '../backoffice/layout'
    
    # GET /console/setting_planet/:fandom_id
    def setting_planet
    
    end
    
    # GET /console/admin
    def admin
    end
    
    # GET /console/site_config
    def site_config
    end
    
    # GET /console/debug
    def debug
    end
    
    private
    def check_login
        redirect_to root_path unless user_signed_in?
    end
    
    def check_authorize
    end
    
    def set_fandom
        return redirect_to root_path if params[:fandom_id].nil? || params[:fandom_id].zero? || params[:fandom_id].to_i.zero? || params[:fandom_id].length.zero?
        @fandom = Fandom.find(params[:fandom_id])
    end
end
