class Fandom < ApplicationRecord
    has_many :myfandoms, dependent: :destroy
    has_many :links, dependent: :destroy
    
    def user_lists
        self.myfandoms.all&.map{|mf| mf.user}
    end
end
