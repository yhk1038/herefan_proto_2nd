class Wiki < ApplicationRecord
    belongs_to :fandom
    belongs_to :wiki
    has_many :wikis
    has_many :wiki_pointers, dependent: :destroy
end
