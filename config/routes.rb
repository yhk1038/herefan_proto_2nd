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
    get 'home/index', to: 'home#index', as: 'home_my'
    post '/crawler/uri_spy', to: 'home#uri_spy', as: 'crawling_uri'
    
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
