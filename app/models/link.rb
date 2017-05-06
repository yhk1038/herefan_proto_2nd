class Link < ApplicationRecord
    has_many :visited_links, dependent: :destroy
    belongs_to :user
    belongs_to :fandom
end
