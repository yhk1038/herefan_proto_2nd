class Backoffice::ConsoleController < ApplicationController
    include WikisHelper
    
    before_action :check_login
    before_action :check_authorize
    before_action :set_fandom, only: [:setting_planet]
    before_action :set_info, only: [:update_wiki_info, :delete_wiki_info]

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
        
        create_wikis if @fandom.wikis.count.zero?
        @wiki = @fandom.wikis.where(wiki_id: nil).take
        @sub_wikis = @wiki.wikis
    end
    
    def create_wikis
        dummy_wiki_append
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

    def save_planet_wiki
        pa = params[:wiki]
        wiki = Wiki.find(pa[:id])
    
        result = wiki.update(name: pa[:name], image: pa[:image])
    
        if result
            redirect_to fandom_path(wiki.fandom)
        else
            redirect_to :back
        end
    end
    
    
    
    
    
    
    ## Wiki Info CRUD
    public
    def create_wiki_info
        @wiki = Wiki.find(params[:wiki_info][:wiki_id])
        @info = WikiInfo.new
        @info.save
        
        @wiki.wiki_infos << @info
    end
    
    def update_wiki_info
        
        if @info.update(info_params)
            return render json: @info, status: :ok
        else
            return render json: @info.errors, status: :unprocessable_entity
        end
    end
    
    def delete_wiki_info
        if @info.delete
            return render json: @info, status: :ok
        else
            return render json: @info.errors, status: :unprocessable_entity
        end
    end
    
    private
    def info_params
        params.require(:wiki_info).permit(:title, :content, :url)
    end
    
    def set_info
        @info = WikiInfo.find(params[:id])
    end
end
