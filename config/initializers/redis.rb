require "redis"
require 'redis/objects'

config = YAML::load(File.open("#{Rails.root}/config/redis.yml"))[Rails.env]

Redis.current = Redis.new(config)