Rails.application.routes.draw do
  get "logout" => "sessions#destroy"
  get "login" => "sessions#new"
  post "login" => "sessions#create"

  resources :articles, except: :destroy

  get 'contact' => 'static#contact'
  get 'privacy' => 'static#privacy'
  root 'static#index'
end
