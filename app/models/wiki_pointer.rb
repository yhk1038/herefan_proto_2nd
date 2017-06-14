class WikiPointer < ApplicationRecord
    belongs_to :wiki
    has_many :wiki_posts
    
    scope :last_sort_num, -> { pluck(:sort_num).sort.last ? pluck(:sort_num).sort.last + 1 : 1}
end
