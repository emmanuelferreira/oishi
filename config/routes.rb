Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  #
  resources :products, only: [:show, :index]
  get "carts", to: "carts#show"

  resources :order_products, only: [:create]
  post "remove_from_cart/:product_id", to: "order_products#remove_from_cart", as: :remove_from_cart
  post "delete_from_cart/:product_id", to: "order_products#delete_from_cart", as: :delete_from_cart
  resources :charges

  resources :playlists, only: [:index, :create, :new]
  resources :orders, only: [:create, :show]


  get "dashboard", to: "dashboards#overview"

end


