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
        return redirect_to root_path if params[:fandom_id].nil? || params[:fandom_id].to_i.zero? || params[:fandom_id].length.zero?
        @fandom = Fandom.find(params[:fandom_id])
        @config = @fandom.configs.count.zero? ? make_fandom_config(@fandom) : @fandom.config
    end
    
    
    
    
    
    
    public
    def save_planet_information
        pa = params[:fd_conf]
        config = FdConf.find(pa[:id])
        
        result = config.update(fd_name: pa[:fd_name], fd_bg_color: pa[:fd_bg_color], fd_logo: pa[:fd_logo], fd_bg_img: pa[:fd_bg_img])
        
        if result
            redirect_to fandom_path(config.fandom)
        else
            redirect_to :back
        end
    end
end
