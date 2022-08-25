Rails.application.routes.draw do
  namespace :api do
    resources :articles
    # resources :users, only: [:create]
    get 'current_user', to: 'users#current_user_info'
    get '/user_info', to: 'users#show'
    get '/users', to: 'users#index'
    # post '/register', to: 'users#create'
    post '/signup', to: 'home#signup'
    patch '/update_account', to: 'users#update'
    post '/login', to: 'home#login'
    delete '/logout', to: 'home#logout'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
