Rails.application.routes.draw do
  get "logout" => "sessions#destroy"
  get "login" => "sessions#new"
  post "login" => "sessions#create"

  get 'edit-profile' => 'users#edit'
  delete 'delete' => 'users#destroy'
  patch 'update-profile' => 'users#update'

  resources :articles
  resources :tags, except: %i[show]
  resources :users, only: %i[index show] do
    member do
      patch 'verify' => 'users#verify'
    end
    collection do
      get 'change-password' => 'users#change_password'
      patch 'change-password' => 'users#update_password'
      get 'leaderboard' => 'users#leaderboard'
    end
  end

  get 'contact' => 'static#contact'
  get 'about' => 'static#about'
  get 'faqs' => 'static#faqs'
  get 'privacy' => 'static#privacy'
  root 'static#index'
end
