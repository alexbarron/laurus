Rails.application.routes.draw do
  devise_for :users, :controllers => {
    registrations: 'registrations'
  }
  
  resources :endpoints
  resources :users
  resources :developer_apps

  get 'static_pages/home'
  get 'developer_apps/:id/manage_grants', to: 'developer_apps#manage_grants'
  put '/developer_apps/:id/archive', to: 'developer_apps#archive'
  put '/developer_apps/:id/unarchive', to: 'developer_apps#unarchive'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "static_pages#home"
end
