class VisitedLink < ApplicationRecord
    belongs_to :user
    belongs_to :link
    
    def self.find_or_create2(user_id, link_id)
        v = where(user_id: user_id, link_id: link_id).first
        if v
            original_viewcount = v.viewcount
            original_viewcount = 0 if v.viewcount.nil?
        
            viewcount = original_viewcount + 1
            v.update(viewcount: viewcount)
        else
            VisitedLink.create do |vl|
                vl.user_id = user_id
                vl.link_id = link_id
                vl.viewcount = 0
            end
        end
    end
end
