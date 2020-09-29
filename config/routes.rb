Rails.application.routes.draw do
  root to: "tasks#index"
  resources :tasks, only: [:create, :index]
  resources :destinations, only: [:index]
  mount ActionCable.server => "/#{ENV.fetch('ACTION_CABLE_PATH')}"
end