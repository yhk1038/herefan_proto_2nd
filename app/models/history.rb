class History < ApplicationRecord
    mount_uploader :img, StoragesUploader
    serialize :img, JSON

    mount_uploader :thumb_img, CropUploader
    serialize :thumb_img, JSON
    
    belongs_to :fandom
    belongs_to :user
    has_many :histories
    belongs_to :history
end
