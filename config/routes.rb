Rails.application.routes.draw do
  # Authentication
  get "logout" => "sessions#destroy"
  get "login" => "sessions#new"
  post "login" => "sessions#create"
  post "signup" => "users#new"

  # WYSIWIG API endpoints for attachments
  put 'wysiwig-attachment' => 'wysiwig_attachments#create'
  delete 'wysiwig-attachment' => 'wysiwig_attachments#destroy'
  
  # Content
  resources :articles
  resources :users

  get 'contact' => 'static#contact'
  get 'privacy' => 'static#privacy'
  root 'static#index'
end
