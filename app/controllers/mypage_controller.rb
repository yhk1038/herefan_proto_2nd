class MypageController < ApplicationController
    before_action :filling_tab_group, only: [:my_channels, :contributed, :watched]
    before_action :my_published_fandoms
    
    def my_channels
        @tabs[0][:active] = 'active'
        
        if user_signed_in?
            @fandoms = current_user.fandoms.published
        else
            @fandoms = []
        end
        
    end
    
    def contributed
        @tabs[1][:active] = 'active'
    end
    
    def watched
        @tabs[0][:active] = 'active'
        ids = current_user.visited_links.pluck(:link_id)
        fandom_ids = current_user.fandoms.published.ids
        @links = Link.where(id: ids, fandom_id: fandom_ids)
    end
    
    def filling_tab_group
        @tabs = []
        # @tabs << { name: 'my channels', path: mypage_my_channels_path, active: '' }
        @tabs << { name: 'cards', path: mypage_watched_path, active: '' }
        @tabs << { name: 'contribution', path: mypage_contributed_path, active: '' }
    end
end
