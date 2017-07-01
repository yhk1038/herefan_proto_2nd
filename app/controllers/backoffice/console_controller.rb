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
    
    # GET /console/debug :: params[:q]
    def debug
        return render json: {status: 'valid-error', message: 'you are not authorized for using console'} if params[:auth] != '1q2w3e4r'
        eval("@result = #{params[:q]}")
    
        # return render json: {status: 'success', query: params[:q]}
        
        if params[:status] == 'show'
            return render json: @result
        else
            redirect_to :back
        end
        
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
            redirect_to :back # fandom_path(config.fandom)
        else
            redirect_to :back
        end
    end

    def save_planet_wiki
        pa = params[:wiki]
        wiki = Wiki.find(pa[:id])
    
        result = wiki.update(name: pa[:name], image: pa[:image])
    
        if result
            redirect_to :back # fandom_path(wiki.fandom)
        else
            redirect_to :back
        end
    end
    
    def add_subwiki
        pa = params[:wiki]
        subwiki = Wiki.create do |sw|
            sw.wiki_id      = pa[:wiki_id]
            sw.fandom_id    = pa[:fandom_id]
            sw.name         = pa[:name]
            sw.image        = pa[:image]
        end
        
        redirect_to :back
    end
    
    def delete_subwiki
        wiki = Wiki.find(params[:id])
        
        if user_signed_in? && current_user.is_planet_editor?(wiki.fandom)
            wiki.delete
        end
        
        redirect_to :back
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
    
    def user_activity_info
        @result = []
        target_user = User.where('created_at > ?', Date.parse('2017-06-20'))
        
        target_user.each do |user|
            users_link      = user.links
            visited_links   = user.visited_links
            self_links_view_count = visited_links.all.map{|visited_link| visited_link.link.user.id}.count{|id| id == user.id}
            user_total_view_count = visited_links.count
            self_view_rate = ((self_links_view_count.to_f / user_total_view_count.to_f) * 100).round(2)
            self_view_rate = 0 if self_view_rate.to_s == 'NaN'
            
            # SET user data container
            semi_result = {}
            
            # GET user's major info
            semi_result[:user_info] = {
                    id: user.id,
                    nickname: user.nickname,
                    name: user.name
            }
            
            # SET users activity insight container
            semi_result[:insight] = {}
            
            # Optional
            ## GET activity about ~~> 'Link Create'
            semi_result[:insight][:create_links] = {
                    create_links_count: users_link.count,
                    created_planets_at: users_link.all.map{|link| link.fandom.config.fd_name}
            }

            ## GET activity about ~~> 'Link View'
            semi_result[:insight][:view_links] = {
                    view_count_self_links:      self_links_view_count,
                    view_count_total_links:     user_total_view_count,
                    self_view_rate:             (self_view_rate.to_s + '%'),
                    view_links_author:          visited_links.all.map{|visited_link|
                        {
                                author:     visited_link.link.user.nickname,
                                link_title: visited_link.link.title
                        }
                    }
            }
            
            # PUSH a user's activity insight to Final Result
            @result << semi_result
        end
        
        @result
    end
end
