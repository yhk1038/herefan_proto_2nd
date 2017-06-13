class WikiPointer < ApplicationRecord
    belongs_to :wiki
    has_many :wiki_posts
end
