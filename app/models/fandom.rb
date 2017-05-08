class Fandom < ApplicationRecord
    has_many :myfandoms, dependent: :destroy
    has_many :links, dependent: :destroy
    has_many :users, through: :links
    
    default_scope { where(published: true) }
    scope :unpublished, -> { unscoped.where(published: false) }
    
    def user_lists
        self.myfandoms.all&.map{|mf| mf.user}
    end
end
