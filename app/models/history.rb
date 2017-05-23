class History < ApplicationRecord
    mount_uploader :img, StoragesUploader
    serialize :img, JSON

    mount_uploader :thumb_img, StoragesUploader
    serialize :thumb_img, JSON
    
    belongs_to :fandom
    belongs_to :user
end
