Rails.application.routes.draw do
  namespace :api do
    resources :articles
    # resources :users, only: [:create]
    get 'current_user', to: 'users#current_user_info'
    get '/user_info/:id', to: 'users#show'
    get '/users', to: 'users#index'
    delete '/users/:id', to: 'users#destroy'
    # post '/register', to: 'users#create'
    post '/signup', to: 'home#signup'
    patch '/update_account', to: 'users#update'
    post '/login', to: 'home#login'
    delete '/logout', to: 'home#logout'
    resources :categories, except: [:destroy]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
