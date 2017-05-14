class Like < ApplicationRecord
    belongs_to :user
    belongs_to :link
    validates :user, :link, presence: true
end
