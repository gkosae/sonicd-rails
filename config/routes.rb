Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks, only: %i[create index]
  resources :destinations, only: [:index]
  get 'hooks/health', to: 'hooks#health'
  post 'hooks/sentry', to: 'hooks#sentry'
  mount ActionCable.server => "/#{ENV.fetch('ACTION_CABLE_PATH')}"
end
