require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'

class HomeController < ApplicationController
    before_action :filling_tab_group, only: [:index, :new_content]
    before_action :my_published_fandoms

    def go_for
        if user_signed_in?
            if current_user.fandoms.published.count.zero?
                redirect_to fandoms_path
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
    
    
    
    # GET '/sort_by/:req' :: params[:req] == 'watched' or 'clip' or 'maum'
    def sort_by
        @req = params[:req] || 'watched'
        bridge = []
        
        case @req
        when 'watched'
            bridge = current_user.visited_links
        when 'clip'
            bridge = current_user.clips
        when 'maum'
            bridge = current_user.likes
        end

        @links = bridge.map{|a| a.link}.sort{|a, b| b.created_at <=> a.created_at }
    end
    
    

    # POST '/utils/user_watched_this_link' :: params[:user_id], params[:link_id], as: visited_link_counter
    def visited_link_counter
        VisitedLink.find_or_create2(params[:user_id], params[:link_id])
        render json: nil, status: :ok
    end

    # POST '/crawler/uri_spy :: params[:url]' as: crawling_uri_path(url)
    def uri_spy

        uri = params[:url]

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
end
