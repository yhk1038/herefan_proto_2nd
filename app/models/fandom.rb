class Fandom < ApplicationRecord
    has_many :myfandoms, dependent: :destroy
    has_many :links, dependent: :destroy
    has_many :users, through: :links
    
    # default_scope { where(published: true) }
    scope :published,   -> { where(published: true) }
    scope :unpublished, -> { where(published: false) }
    
    def user_lists
        self.myfandoms.all&.map{|mf| mf.user}
    end
    
    def get_myfandom
        user_signed_in? ? self.myfandoms.where(user: current_user).take : false
    end
end
