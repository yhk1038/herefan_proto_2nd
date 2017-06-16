class Fandom < ApplicationRecord
    
    ## =>
    has_many :fd_confs,     dependent: :destroy
    
    ## =>
    has_many :wikis,        dependent: :destroy
    has_many :histories,    dependent: :destroy
    has_many :links,        dependent: :destroy
    has_many :schedules,    dependent: :destroy
    
    ## =>
    has_many :users,        through: :myfandoms
    has_many :myfandoms,    dependent: :destroy
    
    # default_scope { where(published: true) }
    scope :published,   -> { where(published: true) }
    scope :unpublished, -> { where(published: false) }
    scope :links_all, -> { order(created_at: :desc).all.map{|fandom| fandom.links}.flatten.sort{|a, b| b.created_at <=> a.created_at } }
    scope :links_all_at_homeMy, -> { order(created_at: :desc).all.map{|fandom| fandom.links}.flatten.sort{|a, b| b.created_at <=> a.created_at }.last(30) }

    def config
        self.fd_confs.last
    end
    
    def configs
        self.fd_confs
    end
    
    def user_lists
        self.myfandoms.all&.map{|mf| mf.user}
    end
    
    def get_myfandom(user)
        self.myfandoms.where(user: user).take
    end
end
