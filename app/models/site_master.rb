class SiteMaster < ApplicationRecord
    after_create :set_default_values
    
    def set_default_values
        self.fandom_publish_count = 2 if self.fandom_publish_count.nil?
        self.save
    end
end
