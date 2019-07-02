Rails.application.routes.draw do
  get "logout" => "sessions#destroy"
  get "login" => "sessions#new"
  post "login" => "sessions#create"

  resources :articles

  get 'contact' => 'static#contact'
  get 'about' => 'static#about'
  get 'faqs' => 'static#faqs'
  get 'privacy' => 'static#privacy'
  root 'static#index'
end
