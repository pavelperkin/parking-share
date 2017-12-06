Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users
  resources :users, only: [:index, :create, :edit, :update, :destroy]
  resource :profile
end
