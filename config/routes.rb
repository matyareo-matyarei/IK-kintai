Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  get "users/show" => "users#show"
  root to: "attendances#new"
  resources :attendances, only: [:new, :create, :destroy] do
    collection do
      get 'assist'
      get 'line'
    end
  end
  post "/" => "attendances#create"
  get "/attendances" => "attendances#new"
  resources :users, only: :show
  get "/users" => "attendances#new"
end
