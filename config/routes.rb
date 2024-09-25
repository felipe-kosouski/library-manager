Rails.application.routes.draw do
  apipie
  root "books#index"

  namespace :admin do
    resources :users
    resources :books
  end

  namespace :api do
    namespace :v1 do
      resources :borrowings do
        member do
          patch :return
        end
      end
      resources :books, only: %i[index show create update destroy]
    end
  end

  devise_for :users

  resources :borrowings do
    member do
      patch :return
    end
  end
  resources :books, only: %i[index show]

  get "/dashboard", to: "dashboards#index"
  get "/librarian_dashboard", to: "dashboards#librarian_dashboard"
  get "/member_dashboard", to: "dashboards#member_dashboard"

  get "up" => "rails/health#show", as: :rails_health_check

  match '*path', to: 'application#route_not_found', via: :all
end
