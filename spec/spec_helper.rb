$: << File.expand_path(".")

Dir["spec/support/**/*.rb"].each { |file| require file }

ENV["RACK_ENV"] = "test"
ENV["REDIS_URL"] = "redis://rediswoohoo:abc123@example.com:12345/"

require "byebug"
