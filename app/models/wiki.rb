class Wiki < ApplicationRecord
    belongs_to :fandom
    belongs_to :wiki
    has_many :wikis
end
