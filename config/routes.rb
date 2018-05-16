Rails.application.routes.draw do
  devise_for :users
  resources :comments
  resources :articles
  resources :projects

  root 'home#index'
end
