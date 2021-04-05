require 'figaro'

Figaro.application = Figaro::Application.new(
  environment: fetch(:stage),
  path: File.expand_path('config/application.yml', __dir__)
)

Figaro.load

require 'sshkit/sudo'
require 'capistrano/setup'
require 'capistrano/deploy'

require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

require 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/figaro_yml'
require 'capistrano/simple_systemd'

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
