class Report < ApplicationRecord
  belongs_to :user
  belongs_to :link
  belongs_to :wiki_post
  belongs_to :history
  belongs_to :schedule
  belongs_to :fandom
end
