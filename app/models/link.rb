class Link < ApplicationRecord
    has_many :visited_links, dependent: :destroy
    has_many :likes, dependent: :destroy
    has_many :clips, dependent: :destroy
    belongs_to :user
    belongs_to :fandom
end
