Rails.application.routes.draw do
    
    match 'hf_util/user_must_have_unique_myfandom/:id', to: 'hf_util#user_must_have_unique_myfandom', via: [:get]

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

    scope module: :action do
        resources :likes, path: '/action/likes'
        resources :clips, path: '/action/clips'
    end
    
    scope module: :planet do
        resources :schedules, path: '/planet/schedules'
    end
    
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

    # Admin Dashboard
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    
    # Error Page
    %w( 404 422 500 ).each do |code|
        get "/#{code}", to: 'errors#show', code: code
    end

end
