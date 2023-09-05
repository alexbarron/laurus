Rails.application.routes.draw do
  resources :users
  resources :developer_apps
  devise_for :users, :controllers => {
    registrations: 'registrations'
  }
  get 'static_pages/home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "static_pages#home"
end
