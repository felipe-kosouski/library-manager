Rails.application.routes.draw do
  devise_for :users

  root "dashboards#index"

  resources :borrowings do
    member do
      patch :return
    end
  end
  resources :books

  get '/librarian_dashboard', to: 'dashboards#librarian'
  get '/member_dashboard', to: 'dashboards#member'

  get "up" => "rails/health#show", as: :rails_health_check
end
