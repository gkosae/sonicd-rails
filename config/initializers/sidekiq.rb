redis_conf = { url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } }

Sidekiq.configure_server do |config|
  config.options[:concurrency] = (ENV.fetch('SIDEKIQ_CONCURRENCY') { '4' }).to_i
  config.redis = redis_conf
end

Sidekiq.configure_client do |config|
  config.redis = redis_conf
end

schedule_file = 'config/schedule.yml'
if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.destroy_all!
  Sidekiq::Cron::Job.load_from_hash(YAML.load_file(schedule_file))
end