Rails.application.routes.draw do
  resources :spot_feeds

  resources :spot_messages

  mount Upmin::Engine => '/admin'
  root to: 'visitors#index'
  devise_for :users
  resources :users
end
