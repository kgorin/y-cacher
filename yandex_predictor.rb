require "net/http"
require "uri"

URL = "https://predictor.yandex.net/api/v1/predict.json/complete"

class YandexPredictor
  class << self
    def get(api_key, query)
      url = build_url(api_key, query)
      puts "URL: #{url}"
      Net::HTTP.get(URI.parse(url))
    end

    private
    def build_url(api_key, query)
      query_string = Rack::Utils.build_query(
        key: api_key,
        q: query,
        lang: 'en',
        limit: 3
      )

      "#{URL}?#{query_string}"
    end
  end
end
