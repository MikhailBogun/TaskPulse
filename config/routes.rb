Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users,
    path: "",
    path_names: {
      sign_in: "api/v1/auth/login",
      sign_out: "api/v1/auth/logout",
      registration: "api/v1/auth/register"
    },
    controllers: {
      sessions: "api/v1/auth/sessions",
      registrations: "api/v1/auth/registrations"
    }

  namespace :api do
    namespace :v1 do
      get "auth/me", to: "auth/users#me"

      resources :tasks, only: %i[index show create update destroy]
      resources :categories, only: %i[index show create update destroy]

      namespace :subscriptions do
        post "checkout", to: "checkouts#create"
        post "portal", to: "portals#create"
      end

      get "dashboard", to: "dashboard#index"

      resources :alert_rules, only: %i[index show create update destroy]
    end
  end
end
