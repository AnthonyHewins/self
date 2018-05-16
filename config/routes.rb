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
  resources :users do
    collection do
      get "confirm/:confirmation_token", to: "users#confirm_email", as: "confirm_email"
    end
  end

  get 'contact' => 'static#contact'
  get 'privacy' => 'static#privacy'
  root 'static#index'
end
