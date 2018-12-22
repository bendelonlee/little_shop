Rails.application.routes.draw do
  root 'items#index'
  namespace :admin do
    get 'merchants/:id', to: "users#merchant_show", as: "merchant"
    get 'users/:id', to: "users#show", as: "user"
    get 'users', to: "users#index", as: "users"
    patch 'disable_user/:id', to: "users#update", as: "disable_user"
    patch 'enable_user/:id', to: "users#update", as: "enable_user"
  end

  resources :items
  resources :carts, only: [:create]
  resources :users, only: [:index, :create, :edit]

  namespace :profile do
    get '', to: 'users#show'
    resources :orders, only: [:show, :destroy, :index, :create] do
      resources :order_items, only: [:update]
    end
    get '/edit', to: 'users#edit', as: "edit"
    post '/update', to: 'users#update'
    patch '/update', to: 'users#update'
  end

  get '/cart', to: 'carts#show'
  patch '/cart', to: 'carts#update'
  delete '/cart', to: 'carts#delete'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :dashboard do
    get "", to: 'users#show'
    get "/items", to: 'items#index'
    get '/items/new', to: 'items#new'
    get "/items/edit/:id", to: "items#edit", as: "item_edit"
    get "/orders", to: 'orders#index'
    get "/orders/:id", to: "orders#show", as: "order"
    delete "/items/delete/:id", to: "items#destroy", as: "item"
    patch "/items/toggle/:id", to: "items#toggle", as: "item_toggle"
    post "/items", to: "items#create", as: "create_item"
  end

  get '/register', to: 'users#new'
  get '/merchants', to: 'users#index'
  get '/merchants/:id', to: 'users#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
