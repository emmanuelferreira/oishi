Rails.application.routes.draw do
  get 'shopping_cart/index'
  get 'shopping_cart/create'
  get 'shopping_cart/delete'
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :products, only: [:show, :index]
  resources :playlists, only: [:index, :create, :new]
  resources :orders, only: [:show, :new, :create]
  resources :carts
  resources :order_products
  get "dashboard", to: "dashboards#overview"

end


