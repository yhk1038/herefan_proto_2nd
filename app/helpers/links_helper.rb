module LinksHelper
    
    def permitted_user?(link, user, current_user)
        permit = false
        permit = true if link.user == current_user || user&.is_planet_editor?(link.fandom) || user&.admin
        return permit
    end
    
    def get_links_info0(link, user_id)
        myclips = Clip.where(link: link, user_id: user_id)
        myclips_already = myclips.count.zero? ? false : true
    
        mylikes = Like.where(link: link, user_id: user_id)
        mylikes_already = mylikes.count.zero? ? false : true
    
        myvisites = VisitedLink.where(link: link, user_id: user_id)
        myvisites_already = myvisites.count.zero? ? false : true
    
        visited_count = link.visited_links.pluck(:viewcount).inject(:+)
        
        return myclips_already, mylikes_already, myvisites_already, visited_count
    end
    
    def get_link_info(link, user)
        result = {}

        my_fandom               = is_my_fandom?(user: user, fandom: link.fandom)
        open_edit_fandom_modal  = "open_edit_modal(#{link.id})"
        open_report_alert       = "report_alert(#{link.id}, #{user&.id ? user.id : 0});"

        result[:author]             = link.user
        result[:edit_script]        = valid_display_on_user_level(my_fandom, script: open_edit_fandom_modal)
        result[:report_script]      = valid_display_on_user_level(my_fandom, script: open_report_alert)
        result[:no_follow_script]   = valid_display_on_user_level(my_fandom, mute_level: 'follower')
        
        return result
    end
end
