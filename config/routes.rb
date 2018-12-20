Rails.application.routes.draw do
  root 'items#index'
  namespace :admin do
    get 'merchants/:id', to: "users#show", as: "merchant"
    get 'users/:id', to: "users#show", as: "user"
    get 'users', to: "users#index", as: "users"
    patch 'disable_user/:id', to: "users#update", as: "disable_user"
    patch 'enable_user/:id', to: "users#update", as: "enable_user"
  end

  resources :items
  resources :carts, only: [:create]
  resources :users, only: [:index, :create, :edit]
  resources :orders, only: [:create, :show]


  get '/profile', to: 'users#show'

  get '/cart', to: 'carts#show'
  patch '/cart', to: 'carts#update'
  delete '/cart', to: 'carts#delete'
  get '/profile/orders', to: 'orders#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :dashboard do
    get "", to: 'users#show'
    get "/items", to: 'items#index'
    get "/orders", to: 'orders#index'
    get "/orders/:id", to: "orders#show"
    get "/items/edit/:id", to: "items#edit", as: "item_edit"
    delete "/items/delete/:id", to: "items#destroy", as: "item"
    patch "/items/toggle/:id", to: "items#toggle", as: "item_toggle"
  end

  get '/register', to: 'users#new'
  get '/merchants', to: 'users#index'
  get '/merchants/:id', to: 'users#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
