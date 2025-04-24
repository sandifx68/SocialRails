Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :users, only: [ :new, :create, :show, :edit, :update ] do
    member do
      get :edit_description
      patch :update_description
      get :edit_photo
      patch :update_photo
      get :edit_background_image
      patch :update_background_image
    end
  end

  root "posts#index"
  get "posts", to: "posts#index"


  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout
end
