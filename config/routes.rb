Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :users, only: [ :new, :create, :show, :edit, :update ]

  root "posts#index"
  get "posts", to: "posts#index"


  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout
end
