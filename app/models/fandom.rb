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
    
    # Callback Functions
    after_create :dummy_wiki_append, :registration_config
    
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
    
    def user_ids
        self.config.userlist.gsub('[','').gsub(']','').split(',').map{|s| s.to_i}
    end
    
    
    private
    ## Callback fandom create
    # dummy wiki
    def dummy_wiki_append
        fandom = self
        
        # main wiki create
        wiki = Wiki.create do |w|
            w.fandom    = fandom
            w.name      = fandom.name
            w.image     = fandom.background_img
        end
        fandom.wikis << wiki
        
        # sub wiki create
        6.times do |i|
            fandom.wikis << Wiki.create do |w|
                w.fandom    = fandom
                w.wiki      = wiki
                w.name      = "member #{i+1}"
                w.image     = fandom.background_img
            end
        end
    end
    
    def registration_config
        fandom = self
        
        init_config = FdConf.create(fd_logo: fandom.profile_img, fd_bg_img: fandom.background_img, fd_name: fandom.name, userlist: [$current_user_id].to_s)
        fandom.configs << init_config
        
        user = User.find_by(id: $current_user_id)
        return init_config unless user
        user.fd_confs << init_config
    end
end
