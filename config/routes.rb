Rails.application.routes.draw do
  
  
  resources :professionals do
    resources :appointments do
      collection do
        delete 'destroy_all', action: "destroy_all", as: 'destroy_all'
      end
    end
  end
  root to: 'home#show'
  get 'home/show'
  
  devise_for :users, controllers: { registrations: 'users/registrations'}
  resources :users
end
