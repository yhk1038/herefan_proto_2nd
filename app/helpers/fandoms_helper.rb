module FandomsHelper
    
    def follow_btn(resource, user)
        btn = '<a class="pv-follow-btn" style="cursor: pointer;" data-toggle="modal" data-target="#login_modal">Follow</a>'
        
        if user
            if user.fandom_lists.include?(resource)
                myfandom = Myfandom.where(user: user, fandom: resource).take
                btn = "<a id='channel_#{resource.id}' onclick='followBtn(\"cancel\", #{myfandom.id}, #{resource.id}, #{user.id}, \"\")' class='pv-follow-btn followed' style='cursor: pointer'><span class='zmdi zmdi-star' style='font-size: 20px; position: relative; top: 2px;'></span> Followed</a>"
            else
                btn = "<a id='channel_#{resource.id}' onclick='followBtn(\"follow\", 0, #{resource.id}, #{user.id}, \"\")' class='pv-follow-btn' style='cursor: pointer'>Follow</a>"
            end
        end
        
        btn
    end
    
    def is_my_fandom?(user: nil, fandom: nil)
        # users_fandom_lists = @my_fandom if users_fandom_lists.nil?
        # if this_fandom
        #     users_fandom_lists.include? this_fandom.id
        # else
        #     users_fandom_lists.count.zero? ? false : true
        # end
        
        fandom.get_myfandom(user)
    end
    
    private
    def set_fandom
        @fandom = Fandom.find(params[:fandom_id])
        @config = @fandom.configs.count.zero? ? make_fandom_config(@fandom) : @fandom.config
    end
    
    def make_fandom_config(fandom)
        init_config = FdConf.create(fd_logo: fandom.profile_img, fd_bg_img: fandom.background_img, fd_name: fandom.name, userlist: [$current_user_id].to_s)
        fandom.configs << init_config
        User.find($current_user_id).fd_confs << init_config unless $current_user_id.zero?
        
        return init_config
    end
end
