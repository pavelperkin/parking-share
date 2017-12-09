Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users
  resources :users, only: [:index, :create, :edit, :update, :destroy]
  resource :profile, only: [:show, :edit, :update, :create]
  resources :cars, only: [:new, :create, :destroy]
  resources :parking_places, only: [:create, :destroy, :update]
  resources :parkings
end
