Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Public pages
  get "examples" => "examples#index", as: :examples
  get "examples/:id" => "examples#show", as: :example

  root "pages#home"

  resources :users
end
