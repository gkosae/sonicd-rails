set :stage, :production
set :branch, 'deploy'
set :user, ENV.fetch('DEPLOY_USER')
server ENV.fetch('DEPLOY_SERVER'), port: ENV.fetch('DEPLOY_SERVER_SSH_PORT'), roles: [:web, :app, :db], primary: true

set :puma_env, fetch(:stage)
set :puma_bind, ENV.fetch('PUMA_BIND')
set :puma_access_log, "#{shared_path}/log/puma.access.log"
set :puma_error_log, "#{shared_path}/log/puma.error.log"
set :puma_workers, 1
set :puma_min_threads, 5
set :puma_max_threads, 5