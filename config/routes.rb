Rails.application.routes.draw do
  resources :app_invitations, only: %i[index show destroy]
  devise_for :users, controllers: {
    registrations:      "registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  resources :endpoints
  resources :users
  resources :developer_apps do
    resources :app_invitations, only: %i[new create]
    resources :app_memberships, only: %i[index edit update destroy]
  end

  get "/static_pages/home"
  get "/developer_apps/:id/activity", to: "developer_apps#activity", as: :developer_app_activity
  get "/developer_apps/:id/settings", to: "developer_apps#settings", as: :developer_app_settings
  get "/developer_apps/:id/manage_grants", to: "developer_apps#manage_grants", as: :manage_developer_app_grants
  put "/developer_apps/:id/archive", to: "developer_apps#archive", as: :archive_developer_app
  put "/developer_apps/:id/unarchive", to: "developer_apps#unarchive", as: :unarchive_developer_app
  get "/developer_apps/:developer_app_id/app_invitations/:id/accept", to: "app_invitations#accept",
                                                                      as: :accept_app_invitation
  get "/developer_apps/:developer_app_id/app_invitations/:id/decline", to: "app_invitations#decline",
                                                                       as: :decline_app_invitation
  post "/endpoints/import", to: "endpoints#import"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "static_pages#home"
end
