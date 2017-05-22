module NavbarHelper
    def nav_menu_lists(version: 'wide', fandoms: nil)
        case version
        when 'wide'
            nav_menu_lists_desktop

        when 'narrow'
            nav_menu_lists_mobile(fandoms)

        end
    end
    
    private
    
    def nav_menu_lists_desktop
        lists = []
        lists << { name: app_home, path: home_my_path, controller: 'home' }
        lists << { name: app_fandom, path: fandoms_path, controller: 'fandoms' }
        lists
    end
    
    def nav_menu_lists_mobile(my_fandoms)
        lists = []
    
        home_tab = {
                name: app_home,
                icon: 'zmdi-home',
                sign_in: false,
                li_class: '',
                ul_style: '',
                sub_menu: [
                                  # {name: 'new',       path: home_my_path},
                                  # {name: 'favorite',  path: home_my_path},
                                  {name: 'my',        path: home_my_path}
                          ]
        }
        lists << home_tab
        
        if my_fandoms
            followed = {
                    name: "followed #{app_fandom}s",
                    icon: 'zmdi-menu',
                    sign_in: true,
                    li_class: 'active toggled',
                    ul_style: 'padding-bottom: 90px;',
                    sub_menu: my_fandoms.all.map{|fandom| {name: fandom.name, path: fandom_path(fandom)}}
            }
            lists << followed
        end
        
        lists
    end
end