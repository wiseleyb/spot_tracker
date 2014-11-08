Rails.application.routes.draw do
  resources :spot_groups

  resources :spot_feeds do
    member do
      get 'import'
    end
  end

  resources :spot_messages

  mount Upmin::Engine => '/admin'
  root to: 'visitors#index'
  devise_for :users
  resources :users
end
