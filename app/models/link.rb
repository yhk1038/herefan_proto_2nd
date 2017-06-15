class Link < ApplicationRecord
    has_many :visited_links, dependent: :destroy
    has_many :likes, dependent: :destroy
    has_many :clips, dependent: :destroy
    belongs_to :user
    belongs_to :fandom
    
    scope :at_home_display, -> { order(created_at: :desc).first(30) }
    
end
