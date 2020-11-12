Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  
  root to: "attendances#new"
  resources :attendances, only: [:new, :create] do
    collection do
      get 'assist'
    end
  end
  post "/" => "attendances#create"
  get "/attendances" => "attendances#new"
  resources :users, only: :show

end
