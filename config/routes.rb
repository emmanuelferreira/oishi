Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :products, only: [:show, :index]
  resources :playlists, only: [:index, :create, :new]
  resources :orders, only: [:show, :new, :create]
  resources :dashboards, only: [:show]
  get "dashboard", to: "dashboards#overview"
end

