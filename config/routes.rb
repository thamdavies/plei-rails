Rails.application.routes.draw do
  # Clearance authentication
  resources :passwords, controller: "clearance/passwords", only: [ :create, :new ]
  resource :session, controller: "clearance/sessions", only: [ :create ]

  resources :users, controller: "clearance/users", only: [ :create ] do
    resource :password,
      controller: "clearance/passwords",
      only: [ :edit, :update ]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Public pages
  get "examples" => "pages#examples", as: :examples
  get "examples/:id" => "pages#show", as: :example

  root "pages#home"
end
