$: << File.expand_path(".")

require "byebug"

Dir["./spec/support/**/*.rb"].sort.each { |file| require file }

ENV["RACK_ENV"] = "test"
ENV["REDIS_URL"] = "redis://rediswoohoo:abc123@example.com:12345/"
