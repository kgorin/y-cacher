require 'singleton'
require 'redis'

PREFIX = 'yandex_predictor'.freeze

class YandexError < StandardError; end

class Cache
  attr_reader :redis

  def initialize
    redis_to_go_url = ENV['REDISTOGO_URL']

    @redis =
      if redis_to_go_url
        uri = URI(redis_to_go_url)
        Redis.new(host: uri.host, port: uri.port, password: uri.password)
      else
        Redis.new(host: 'localhost', port: 6379)
      end
  end

  def set(query, value)
    key = redis_key(query)
    @redis.set(key, value)
  end

  def get(query)
    key = redis_key(query)
    @redis.get(key)
  end

  private

  def redis_key(query)
    "#{PREFIX}:#{query}"
  end
end
