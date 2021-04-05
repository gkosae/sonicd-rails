# config valid only for current version of Capistrano
set :application, 'sonicd-rails'
set :repo_url, 'git@github.com:gkosae/sonicd-rails.git'
set :user, ENV.fetch('DEPLOY_USER')
set :home_dir, "/home/#{fetch(:user)}"
set :deploy_to, "#{fetch(:home_dir)}/apps/#{fetch(:application)}"
set :pty, true

set :service_file_prefix, 'sonicd'

set :rvm_type, :user
set :rvm_ruby_version, '2.7.1'
# set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa)}
set :ssh_options, {}

set :linked_dirs, fetch(:linked_dirs, []).concat(%w[log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system])
set :log_files, %w[sidekiq.log puma.access.log puma.error.log]
set :linked_files, fetch(:linked_files, []).concat(fetch(:log_files, []).map { |log_file| "log/#{log_file}" })
set :linked_files, fetch(:linked_files).concat(%w[config/puma.rb db/production.sqlite3 config/master.key])

set :keep_releases, 1

namespace :deploy do
  namespace :check do
    task :create_log_files do
      on roles(:app) do
        fetch(:log_files, []).each { |log_file| execute :touch, "#{shared_path}/log/#{log_file}" }
      end
    end

    task :create_manifest_files do
      on roles(:app) do
        [
          'manifest.json',
          '.manifest.json',
          '.sprockets-manifest.json'
        ].each { |file| execute :touch, "#{shared_path}/public/assets/#{file}" }
      end
    end
  end
end

namespace :app do
  task :start do
    on roles(:app) do
      invoke 'systemd:puma:start'
      invoke 'systemd:sidekiq:start'
    end
  end

  task :stop do
    on roles(:app) do
      invoke 'systemd:sidekiq:stop'
      invoke 'systemd:puma:stop'
    end
  end

  task :restart do
    on roles(:app) do
      invoke 'systemd:sidekiq:restart'
      invoke 'systemd:puma:reload'
    end
  end
end

namespace :puma do
  task :upload_config do
    on roles(:app) do
      puma_config_template = "#{__dir__}/puma_production.rb.erb"
      config = ERB.new(File.new(puma_config_template).read).result(binding)
      upload! StringIO.new(config), "#{shared_path}/config/puma.rb"
    end
  end
end

set :nginx_server_name, 'sonicd-api.georgeosae.com'
set :nginx_ssl_certificate, ENV.fetch('NGINX_SSL_CERTIFICATE')
set :nginx_ssl_certificate_key, ENV.fetch('NGINX_SSL_CERTIFICATE_KEY')
set :nginx_proxy_pass, ENV.fetch('NGINX_PROXY_PASS')
set :nginx_action_cable_path, ENV.fetch('ACTION_CABLE_PATH')

namespace :nginx do
  task :upload_config do
    on roles(:app) do
      nginx_config_template = "#{__dir__}/nginx.conf.erb"
      config = ERB.new(File.new(nginx_config_template).read).result(binding)
      upload! StringIO.new(config), "#{fetch(:tmp_dir)}/#{fetch(:nginx_server_name)}"

      sudo :mv, "#{fetch(:tmp_dir)}/#{fetch(:nginx_server_name)}", "/etc/nginx/sites-available/#{fetch(:nginx_server_name)}"
      sudo :rm, "/etc/nginx/sites-enabled/#{fetch(:nginx_server_name)}"
      sudo :ln, '-s', "/etc/nginx/sites-available/#{fetch(:nginx_server_name)}", "/etc/nginx/sites-enabled/#{fetch(:nginx_server_name)}"
      sudo :nginx, '-t'
      sudo :service, :nginx, :reload
    end
  end
end

task :upload_master_key do
  on roles(:app), in: :sequence, wait: 10 do
    unless test("[ -f #{shared_path}/config/master.key ]")
      upload! 'config/master.key', "#{shared_path}/config/master.key"
    end
  end
end

task :setup do
  on roles(:app) do
    invoke 'upload_master_key'
    invoke 'puma:upload_config'
  end
end

before 'deploy:check:linked_files', 'upload_master_key'
before 'deploy:check:linked_files', 'deploy:check:create_log_files'
before 'deploy:check:linked_files', 'deploy:check:create_manifest_files'
before 'deploy:check:linked_files', 'systemd:upload'
before 'deploy:check:linked_files', 'puma:upload_config'
after 'deploy:log_revision',     'systemd:puma:restart'
after 'systemd:puma:restart', 'nginx:upload_config'
before 'deploy:symlink:release', 'systemd:sidekiq:stop'
after 'deploy:symlink:release',  'systemd:sidekiq:start'
