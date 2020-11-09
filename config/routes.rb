Rails.application.routes.draw do
  devise_for :users
  root to: "attendances#new"
  resources :attendances, only: [:new, :create]
  post "/" => "attendances#create"
  get "/attendances" => "attendances#new"

end
