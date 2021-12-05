Rails.application.routes.draw do
  
  root to: 'home#show'
  get 'home/show'
  
  devise_for :users, controllers: { registrations: 'users/registrations'}
  resources :users
end
