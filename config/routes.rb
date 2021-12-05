Rails.application.routes.draw do
  
  resources :professionals
  root to: 'home#show'
  get 'home/show'
  
  devise_for :users, controllers: { registrations: 'users/registrations'}
  resources :users
end
