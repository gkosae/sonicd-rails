Sidekiq.configure_server do |config|
  config.options[:concurrency] = 2
end