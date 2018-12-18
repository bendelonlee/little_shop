Rails.application.routes.draw do
  root 'items#index'
  namespace :admin do
    get 'merchants/:id', to: "users#show", as: "merchant"
    get 'users/:id', to: "users#show", as: "user"
    get 'users', to: "users#index", as: "users"
  end
  resources :items
  resources :carts, only: [:create]

  resources :users, only: [:index, :create, :edit] do
    resources :orders, only: [:index]
  end


  get '/profile/:id', to: 'users#show', as: :profile
  get '/profile/orders', to: 'orders#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/dashboard/:id', to: 'users#show'
  get '/register', to: 'users#new'
  get '/merchants', to: 'users#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
