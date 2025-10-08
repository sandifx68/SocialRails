Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :users, only: [ :new, :create, :show, :edit, :update ] do
    resources :friends, only: [ :create, :destroy, :update ], controller: "friendships"
    member do
      get :edit_description
      patch :update_description
      get :edit_photo
      patch :update_photo
      get :edit_background_image
      patch :update_background_image
      get :edit_display_name
      patch :update_display_name
    end
  end
  get "search_users", to: "users#search"
  post "send_message", to: "messages#create"

  get "show_chat/:friend_id", to: "messages#show_chat", as: :show_chat
  post "close_chat", to: "messages#close_chat", as: :close_chat


  root "posts#index"
  get "posts", to: "posts#index"
  resources :posts do
    resources :comments, only: [ :create, :destroy ]
    resources :likes, only: [ :create, :destroy ]
    member do
      get :destroy_confirmation
    end
  end

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout
end
