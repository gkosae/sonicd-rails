Rails.application.routes.draw do
  root to: "tasks#index"
  resources :tasks, only: [:create, :index]
  resources :destinations, only: [:index]
end