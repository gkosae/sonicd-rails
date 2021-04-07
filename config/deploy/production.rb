set :stage, :production
set :branch, 'deploy'
set :user, ENV.fetch('DEPLOY_USER')
server ENV.fetch('DEPLOY_SERVER'), port: ENV.fetch('DEPLOY_SERVER_SSH_PORT'), roles: %i[web app db], primary: true

set :puma_env, fetch(:stage)
set :puma_bind, ENV.fetch('PUMA_BIND')
set :puma_workers, 0
set :puma_min_threads, 1
set :puma_max_threads, 5
