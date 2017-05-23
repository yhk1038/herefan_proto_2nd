class Fandom < ApplicationRecord
    
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
    
    def user_lists
        self.myfandoms.all&.map{|mf| mf.user}
    end
    
    def get_myfandom(user)
        self.myfandoms.where(user: user).take
    end
end
