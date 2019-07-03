Rails.application.routes.draw do
  get "logout" => "sessions#destroy"
  get "login" => "sessions#new"
  post "login" => "sessions#create"

  
  resources :articles
  resources :users, except: %i[create new] do
    collection do
      get 'change-password' => 'users#change_password'
      patch 'change-password' => 'users#update_password'
    end
  end

  get 'contact' => 'static#contact'
  get 'about' => 'static#about'
  get 'faqs' => 'static#faqs'
  get 'privacy' => 'static#privacy'
  root 'static#index'
end
