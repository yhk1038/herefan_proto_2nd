class MypageController < ApplicationController
    before_action :filling_tab_group, only: [:my_channels, :contributed, :watched]
    
    def my_channels
        @tabs[0][:active] = 'active'
        
        if user_signed_in?
            @fandoms = current_user.fandom_lists
        else
            @fandoms = []
        end
        
    end
    
    def contributed
        @tabs[1][:active] = 'active'
    end
    
    def watched
        @tabs[2][:active] = 'active'
        ids = current_user.visited_links.pluck(:link_id)
        @links = Link.where(id: ids)
    end
    
    def filling_tab_group
        @tabs = []
        @tabs << { name: 'my channels', path: mypage_my_channels_path, active: '' }
        @tabs << { name: 'contributed', path: mypage_contributed_path, active: '' }
        @tabs << { name: 'watched', path: mypage_watched_path, active: '' }
    end
end
