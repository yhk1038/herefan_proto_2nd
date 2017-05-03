module FandomsHelper
    
    def follow_btn(resource, user)
        btn = '<a class="pv-follow-btn" style="cursor: pointer;" data-toggle="modal" data-target="#login_modal">Follow</a>'
        
        if user
            if user.fandom_lists.include?(resource)
                myfandom = Myfandom.where(user: user, fandom: resource).take
                btn = "<a id='channel_#{resource.id}' onclick='followBtn(\"cancel\", #{myfandom.id}, #{resource.id}, #{user.id})' class='pv-follow-btn bgm-red' style='cursor: pointer'>Followed</a>"
            else
                btn = "<a id='channel_#{resource.id}' onclick='followBtn(\"follow\", 0, #{resource.id}, #{user.id})' class='pv-follow-btn' style='cursor: pointer'>Follow</a>"
            end
        end
        
        btn
    end
end
