Rails.application.routes.draw do
  get 'shopping_cart/index'
  get 'shopping_cart/create'
  get 'shopping_cart/delete'
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :products, only: [:show, :index]
  get "carts", to: "carts#show"
  post "remove_from_cart/:product_id", to: "order_products#remove_from_cart", as: :remove_from_cart
  delete "delete_from_cart/:product_id", to: "order_products#delete_from_cart", as: :delete_from_cart

  resources :playlists, only: [:index, :create, :new]
  resources :orders, only: [:show, :new, :create]

  resources :order_products
  get "dashboard", to: "dashboards#overview"

end


