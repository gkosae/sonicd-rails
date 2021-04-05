Raven.configure do |config|
  config.dsn = ENV.fetch('SENTRY_DSN')
  config.environments = ['production']
end
