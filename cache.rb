require 'redis'
require 'json'
require './yandex_predictor'

PREFIX = 'yandex_predictor'

class YandexError < StandardError; end

class Cache
  class << self
    def get(api_key, query)
      redis = Redis.new
      prediction = redis.get(redis_key(query))

      if prediction.nil?
        puts 'cache miss, fetching from Yandex'.yellow if verbose?
        result = YandexPredictor.get(api_key, query)

        puts 'Updating cache'.yellow if verbose?
        parsed = JSON.parse(result)
        if parsed['code']
          fail YandexError, parsed.to_s
        end

        redis.set(redis_key(query), result)

        puts 'Done'.yellow if verbose?

        return parsed
      else
        puts 'cache hit'.yellow if verbose?
        parsed = JSON.parse(prediction)
        return parsed
      end
    end

    private

    def redis_key(query)
      "#{PREFIX}:#{query}"
    end

    def verbose?
      true
    end
  end
end
