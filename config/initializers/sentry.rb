Sentry.init do |config|
  config.dsn = 'https://7d7abd20cb1b429d9dcec3931830fbb9@o4505516763250688.ingest.sentry.io/4505522776506368'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 0.1
  # or
  config.traces_sampler = lambda do |context|
    true
  end
end
