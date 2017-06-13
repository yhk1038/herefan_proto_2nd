class WikiPost < ApplicationRecord
    belongs_to :user
    belongs_to :wiki_pointer
end
