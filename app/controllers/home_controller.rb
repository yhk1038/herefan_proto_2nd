require 'nokogiri'
require 'open-uri'

class HomeController < ApplicationController
    before_action :filling_tab_group, only: [:index]
    
    def go_for
        if user_signed_in?
            if current_user.myfandoms.count.zero?
                redirect_to fandoms_path
            else
                redirect_to '/home/index'
            end
        else
            redirect_to fandoms_path
        end
    end
    
    def index
        @links = []
        @links = current_user.links if user_signed_in?
        @fandom_lists = current_user.fandom_lists if user_signed_in?
    end
    
    # POST '/utils/user_watched_this_link' :: params[:user_id], params[:link_id], as: visited_link_counter
    def visited_link_counter
        VisitedLink.find_or_create2(params[:user_id], params[:link_id])
        render json: nil, status: :ok
    end
    
    # POST '/crawler/uri_spy :: params[:url]' as: crawling_uri_path(url)
    def uri_spy
        
        uri = params[:url]
        doc = Nokogiri::HTML(open(uri), 'utf-8')
        # puts doc.search('meta', 'title')

        title       = doc.at("meta[property='og:title']")
        if title.nil?
            title   = doc.search('title').text.strip
        else
            begin
                title   = title['content'].encode('iso-8859-1').force_encoding('utf-8')
            rescue Encoding::UndefinedConversionError => e
                title   = title['content']
            end
        end
        # puts title
        
        
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
                    image = '/svg/main_logo.svg'
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
        
        
        return @target = {
            title: title,
            description: description,
            image: image,
            url: url
        }
    end
    
    def filling_tab_group
        @tabs = []
        @tabs << { name: 'my', path: '', active: 'active' }
    end
end