class FdConf < ApplicationRecord
    belongs_to :fandom
    belongs_to :user
    has_many :users
end
