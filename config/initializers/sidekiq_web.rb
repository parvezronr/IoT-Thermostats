require 'sidekiq/web'

# Sidekiq.configure_server do |config|
#   config.average_scheduled_poll_interval = 2
# end

redis_conf = YAML::load(File.open("#{Rails.root}/config/redis.yml"))[Rails.env]

Sidekiq.configure_server do |config|
  config.failures_max_count = 5000
  config.redis = { url: "redis://#{redis_conf['host']}:#{redis_conf['port']}/0" }
end