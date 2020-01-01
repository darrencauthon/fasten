sidekiq_config = { url: ENV['JOB_WORKER_URL'] }

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
  CronEvent.setup_all
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
  CronEvent.setup_all
end
