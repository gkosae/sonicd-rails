Sidekiq.configure_server do |config|
  config.options[:concurrency] = 8
end

schedule_file = 'config/schedule.yml'
if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.destroy_all!
  Sidekiq::Cron::Job.load_from_hash(YAML.load_file(schedule_file))
end
