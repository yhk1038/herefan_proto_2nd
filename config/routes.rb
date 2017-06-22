Rails.application.routes.draw do
    
    resources :site_masters
    scope module: :backoffice do
        get 'console/setting_planet(/:fandom_id)',  to: 'console#setting_planet'
        post 'console/save_planet_information',     to: 'console#save_planet_information'
        post 'console/save_planet_wiki',            to: 'console#save_planet_wiki'
        post 'console/add_subwiki',                 to: 'console#add_subwiki'
        get 'console/delete_subwiki/:id',           to: 'console#delete_subwiki'
        post 'console/create_wiki_info',            to: 'console#create_wiki_info'
        post 'console/update_wiki_info/:id',        to: 'console#update_wiki_info'
        post 'console/delete_wiki_info/:id',        to: 'console#delete_wiki_info'
        
        get 'console/admin'
    
        get 'console/site_config'
    
        get 'console/debug'
    end

    ## User
    devise_for :users, :controllers => {
            sessions: 'users/sessions',
            registrations: 'users/registrations',
            confirmations: 'users/confirmations',
            passwords: 'users/passwords',
            omniauth_callbacks: 'users/omniauth_callbacks'
    }

    resources :myfandoms

    resources :links
    resources :fandoms do
        scope module: :planet do
            resources :wikis
            resources :histories
            resources :schedules

            resources :wiki_posts
        end
    end

    scope module: :action do
        resources :likes, path: '/action/likes'
        resources :clips, path: '/action/clips'
    end

    root 'home#go_for'
    
    # query
    # > sort by : watched, clip, maum
    get '/sort_by/:req', to: 'home#sort_by'
    

    # home
    # > my
    get 'home/index', to: 'home#index', as: 'home_my'

    # > new
    get 'home/new', to: 'home#new_content', as: 'home_new'

    # my page
    # > my channels
    get 'mypage/my_channels', as: 'mypage_my_channels'

    # > contributed
    get 'mypage/contributed', as: 'mypage_contributed'

    # > watched
    get 'mypage/watched', as: 'mypage_watched'

    # Utility
    # > wiki post Img uploader
    post '/summernote_imageUpload', to: 'hf_util#wiki_image_uploader'
    
    # > url crawler
    post '/crawler/uri_spy', to: 'home#uri_spy', as: 'crawling_uri'

    # > link visiting counter
    post '/utils/user_watched_this_link', to: 'home#visited_link_counter', as: 'visited_link_counter'

    # > letter_counter
    get '/letter_counter', to: 'home#letter_count'

    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    # Admin Dashboard
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

    # Error Page
    %w( 404 422 500 ).each do |code|
        get "/#{code}", to: 'errors#show', code: code
    end

    # Debug
    match 'hf_util/user_must_have_unique_myfandom/:id', to: 'hf_util#user_must_have_unique_myfandom', via: [:get]
    match 'hf_util/history/dummy/:to_do', to: 'hf_util#dummy_push', via: [:get]
end
