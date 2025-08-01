Rails.application.routes.draw do
  resources :policies
  devise_for :users
  root "policies#index"
end
