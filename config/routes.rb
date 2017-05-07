Rails.application.routes.draw do
    resources :links
    resources :myfandoms
    resources :fandoms
    devise_for :users, :controllers => {
            sessions: 'users/sessions',
            registrations: 'users/registrations',
            confirmations: 'users/confirmations',
            passwords: 'users/passwords',
            omniauth_callbacks: 'users/omniauth_callbacks'
    }
    
    root 'home#go_for'
    
    # home
    # > my
    get 'home/index', to: 'home#index', as: 'home_my'
    
    # my page
    # > my channels
    get 'mypage/my_channels', as: 'mypage_my_channels'
    
    # > contributed
    get 'mypage/contributed', as: 'mypage_contributed'
    
    # > watched
    get 'mypage/watched', as: 'mypage_watched'
    
    # Utility
    # > url crawler
    post '/crawler/uri_spy', to: 'home#uri_spy', as: 'crawling_uri'
    
    # > link visiting counter
    post '/utils/user_watched_this_link', to: 'home#visited_link_counter', as: 'visited_link_counter'
    
    # > letter_counter
    get '/letter_counter', to: 'home#letter_count'
    
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
