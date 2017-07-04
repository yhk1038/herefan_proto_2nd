class Link < ApplicationRecord
    has_many :visited_links, dependent: :destroy
    has_many :likes, dependent: :destroy
    has_many :clips, dependent: :destroy
    belongs_to :user
    belongs_to :fandom
    
    scope :at_home_display, -> { order(created_at: :desc).first(30) }
    
    ## Display on a Card
    # Cards Init
    def card_init(user_id)
        self.myclips(user_id)
        self.myvisites(user_id)
        self.mylikes(user_id)
        
        return self
    end
    
    
    # Cards type
    def type_display
        display_on_card = ''
        display_on_card = "type-#{self.typee}" if self.type_defined? && self.valid_type?
        return display_on_card
    end

    def type_defined?
        self.typee ? true : false
    end

    def valid_type?
        self.typee >= 1 && self.typee <= 3 ? true : false
    end
    
    # Cards clip
    def myclips(user_id)
        @myclips = self.clips.where(user_id: user_id)
        @is_clipped = @myclips.count.zero? ? false : true
        return @myclips
    end
    
    def clip_display
        @is_clipped ? 'clipped' : nil
    end
    
    def clip_remote_method
        @is_clipped ? 'delete' : 'post'
    end
    
    def clip_remote_target
        @is_clipped ? @myclips.take.id : self.id
    end

    # Cards maum
    def mylikes(user_id)
        @mylikes = self.likes.where(user_id: user_id)
        @is_liked = @mylikes.count.zero? ? false : true
        return @mylikes
    end
    
    def like_display
        @is_liked ? 'zmdi-favorite' : 'zmdi-favorite-outline'
    end
    
    def like_remote_method
        @is_liked ? 'delete' : 'post'
    end
    
    def like_remote_target
        @is_liked ? @mylikes.take.id : self.id
    end
    
    # Cards visit
    def myvisites(user_id)
        @myvisits = self.visited_links.where(user_id: user_id)
    end
    
    def visit_display
        display_on_card = ''
        display_on_card = 'visited' if self.visited_link?
        return display_on_card
    end
    
    def visited_link?
        @myvisits.count.zero? ? false : true
    end
    
    def visited_count
        counter = self.visited_counter
        count = counter ? counter : 0
        return count
    end
    
    def visited_counter
        self.visited_links.pluck(:viewcount).inject(:+)
    end
end
