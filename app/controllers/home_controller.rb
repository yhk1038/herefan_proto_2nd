require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'

class HomeController < ApplicationController
    before_action :filling_tab_group, only: [:index, :new_content]
    before_action :my_published_fandoms

    def go_for
        if user_signed_in?
            if current_user.fandoms.published.count.zero?
                redirect_to home_my_path
            else
                redirect_to home_my_path
            end
        else
            redirect_to home_new_path
        end
    end

    def new_content
        @tabs[0][:active] = 'active'
        @links = []
        @links = Link.at_home_display
        @fandoms = current_user.fandoms.published if user_signed_in?
    end

    def index
        @tabs[1][:active] = 'active'
        @links = []
        @links = current_user.fandoms.links_all_at_homeMy if user_signed_in?
        @fandoms = current_user.fandoms.published if user_signed_in?
    end

    # GET /u/d
    def destroy2
        if current_user.update(active: false)
            puts "\tDestroy Session! and Active Falsed!"
            redirect_to destroy_user_session_path
        else
            redirect_to :back
        end
    end
    
    
    
    # GET '/sort_by/:req' :: params[:req] == 'watched' or 'clip' or 'maum'
    def sort_by
        @req    = params[:req] || 'watched'
        
        limit   = 30
        limit   = params[:cards_limit]    if params[:cards_limit]
        
        page    = 1
        page    = params[:page]           if params[:page]
        
        bridge  = []

        puts "\n\n\n"
        puts "limit: #{limit}"
        puts "page: #{page}"
        puts "\n\n\n\n"
        
        case @req
        when 'watched'
            bridge = current_user.visited_links.order(updated_at: :desc).limit(limit).offset(limit * (page - 1))
            puts "\n\n\ncount: #{bridge.count}\n\n\n\n"
            bridge = bridge.map{|a| a.link}
            @sorting_method = 'watched'
            #.sort{|a, b| b.visited_links.where(user: current_user).last.updated_at <=> a.visited_links.where(user: current_user).last.updated_at }
            
        when 'clip'
            bridge = current_user.clips.order(created_at: :desc).limit(limit).offset(limit * (page - 1))
            bridge = bridge.map{|a| a.link}
            @sorting_method = 'clip'
            #.sort{|a, b| b.clips.where(user: current_user).last.created_at <=> a.clips.where(user: current_user).last.created_at }
        
        when 'maum'
            bridge = current_user.likes.order(created_at: :desc).limit(limit).offset(limit * (page - 1))
            bridge = bridge.map{|a| a.link}
            @sorting_method = 'maum'
            #.sort{|a, b| b.likes.where(user: current_user).last.created_at <=> a.likes.where(user: current_user).last.created_at }
            
        end

        @links = bridge
    end
    
    

    # POST '/utils/user_watched_this_link' :: params[:user_id], params[:link_id], as: visited_link_counter
    def visited_link_counter
        VisitedLink.find_or_create2(params[:user_id], params[:link_id])
        render json: nil, status: :ok
    end

    # POST '/crawler/uri_spy :: params[:url]' as: crawling_uri_path(url)
    def uri_spy

        uri = params[:url]
        @edit = false
        @edit = true if params[:edit] == 'true'

        doc = Nokogiri::HTML(open(uri, :allow_redirections => :all))
        begin
            puts doc.at("meta[property='og:title']")
        rescue ArgumentError => e
            puts "\n\n\n:::::::: ArgumentError ^^\n\n\n\n"
            doc = Nokogiri::HTML(open(uri, 'r:binary', :allow_redirections => :all).read.encode('utf-8','euc-kr'))
        end
        # puts doc.search('meta', 'title')

        title       = doc.at("meta[property='og:title']")
        puts title
        if title.nil?
            title   = doc.search('title').text.strip
        else
            begin
                title   = title['content'].encode('iso-8859-1').force_encoding('utf-8')
            rescue Encoding::UndefinedConversionError => e
                title   = title['content']
            end
        end
        puts title


        description = doc.at("meta[property='og:description']")
        if description.nil?
            description   = doc.search('description').text.strip
        else
            begin
                description   = description['content'].encode('iso-8859-1').force_encoding('utf-8')
            rescue Encoding::UndefinedConversionError => e
                description   = description['content']
            end
        end
        # puts description

        image       = doc.at("meta[property='og:image']")
        if image.nil?
            image   = doc.at("meta[name='twitter:image']")
            if image.nil?
                image   = doc.at("meta[name='weibo:webpage:image']")
                if image.nil?
                    # image   = doc.at("meta[name='naverblog:profile_image']")
                    # if image.nil?
                        image = '/svg/main_logo.svg'
                    # else
                    #     image = image['content']
                    # end
                else
                    image = image['content']
                end
            else
                image = image['content']
            end
        else
            image   = image['content']
        end
        # puts image


        url         = doc.at("meta[property='og:url']")
        if url.nil?
            url     = uri
        else
            url     = url['content']
        end
        # puts url


        description = descriptionate(description)
        image       = imaginate(image, url)
        return @target = {
            title: title,
            description: description,
            image: image,
            url: url
        }
    end
    
    def descriptionate(description)
        puts ''
        puts ''
        puts description
        puts ''
        puts ''
        if description.class.name == 'String'
            puts 'string'
            puts ''
            
            begin
                description.gsub(/(\n)/,' ')
            rescue ArgumentError => e
                # ec = Encoding::Converter.new('euc-kr', 'utf-8')
                # puts ec.convert(description)
                # puts ec.finish
                description = ''
                return description
            end
            
            d = description&.gsub(/(\n)/,' ')
            d = d&.gsub(/(\r)/,' ')
            return d
        else
            puts 'no string'
            puts ''
            return description
        end
    end
    
    def imaginate(image, url)
        split = url.split('://')
        protocol    = split[0]
        domain      = split[1].split('/').first
        return image if image == '/svg/main_logo.svg'
        image = image.first == '/' ? ( protocol + '://' + domain + image ) : image
        image
    end

    def filling_tab_group
        @tabs = []
        @tabs << { name: 'new', path: home_new_url, active: '' }
        @tabs << { name: 'my', path: home_my_url, active: '' }
    end


    # GET /letter_count
    def letter_count
        render layout: false
    end
    
    
    ###
    ### 무한 스크롤 그룹
    
    # GET /load_card/:page_num
    def load_card
        req     = params[:req]
        page    = params[:page_num].to_i || 1
        limit   = 30
        puts "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
        puts "req: #{req}"
        puts "page: #{page}"
        puts "limit: #{limit}"
        puts "\n\n"
        cards = Link.where(id: 0)
        
        if req
            puts "req: #{req.gsub('-','/')}"
            puts "method: #{params[:method]}\n\n"
            case req.gsub('-','/')
            when 'home/new_content'     # Home > New
                cards = Link.order(created_at: :desc).limit(limit).offset(limit * (page - 1))
                
            when 'home/index'           # Home > My
                cards = current_user.links.where(fandom_id: current_user.fandoms.published.ids).order(created_at: :desc).limit(limit).offset(limit * (page - 1))
            
            when 'fandoms/show'         # Planet > Library
                filter = params[:method].split('-')[0]
                sort = params[:method].split('-')[-1]
                
                case filter
                when 'default'
                    cards = Fandom.find(params[:fandom_id]).links.order(created_at: :desc).limit(limit).offset(limit * (page - 1))
                    puts 'Lib > default cards loaded'
                when 'all'
                    cards = Fandom.find(params[:fandom_id]).links.order(created_at: :desc).limit(limit).offset(limit * (page - 1))
                    puts 'Lib > all cards loaded'
                when 'image'
                    cards = Fandom.find(params[:fandom_id]).links.where(typee: 1).order(created_at: :desc).limit(limit).offset(limit * (page - 1))
                    puts 'Lib > image cards loaded'
                when 'video'
                    cards = Fandom.find(params[:fandom_id]).links.where(typee: 2).order(created_at: :desc).limit(limit).offset(limit * (page - 1))
                    puts 'Lib > video cards loaded'
                when 'others'
                    cards = Fandom.find(params[:fandom_id]).links.where(typee: [0, 3]).order(created_at: :desc).limit(limit).offset(limit * (page - 1))
                    puts 'Lib > others cards loaded'
                end
                
                case sort
                when 'default'
                    # cards = cards
                when 'Latest'
                
                when 'Popular'
                
                when 'Unwatched'
                
                when 'Clipped'
                
                end
                
            when 'mypage/watched'       # Mypage > My Links
                
                case params[:method]
                when 'watched'
                    cards = current_user.visited_links.order(updated_at: :desc).limit(limit).offset(limit * (page - 1)).map{|a| a.link}
                    
                when 'clip'
                    cards = current_user.clips.order(created_at: :desc).limit(limit).offset(limit * (page - 1)).map{|a| a.link}
                    
                when 'maum'
                    cards = current_user.likes.order(created_at: :desc).limit(limit).offset(limit * (page - 1)).map{|a| a.link}
                    
                end
            end
        end
        
        @links = cards
    end

    # GET '/filter_by' :: params[:fandom_id] / params[:method] == 'watched' or 'clip' or 'maum'
    def filter_by
        @fandom = Fandom.find(params[:fandom_id])

        page    = 1
        limit   = 30

        @sorting_method = params[:method]
        cards = Link.where(id: 0)
        
        case @sorting_method
        when 'all'
            cards = @fandom.links.order(id: :desc).limit(limit).offset(limit * (page - 1))
            
        when 'image'
            cards = @fandom.links.where(typee: 1).order(id: :desc).limit(limit).offset(limit * (page - 1))
            
        when 'video'
            cards = @fandom.links.where(typee: 2).order(id: :desc).limit(limit).offset(limit * (page - 1))
            
        when 'others'
            cards = @fandom.links.where(typee: [0, 3]).order(id: :desc).limit(limit).offset(limit * (page - 1))
            
        end
        
        @links = cards
    end
    
end
