Rails.application.routes.draw do
  resources :app_invitations, only: [:index, :show, :destroy]
  devise_for :users, :controllers => {
    registrations: 'registrations'
  }
  
  resources :endpoints
  resources :users
  resources :developer_apps do
    resources :app_invitations, only: [:new, :create]
  end
  resources :app_memberships, only: [:edit, :update, :destroy]

  get 'static_pages/home'
  get 'developer_apps/:id/manage_grants', to: 'developer_apps#manage_grants', as: :manage_developer_app_grants
  put '/developer_apps/:id/archive', to: 'developer_apps#archive', as: :archive_developer_app
  put '/developer_apps/:id/unarchive', to: 'developer_apps#unarchive', as: :unarchive_developer_app
  get '/developer_apps/:developer_app_id/app_invitations/:id/accept', to: 'app_invitations#accept', as: :accept_app_invitation
  get '/developer_apps/:developer_app_id/app_invitations/:id/decline', to: 'app_invitations#decline', as: :decline_app_invitation
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "static_pages#home"
end
