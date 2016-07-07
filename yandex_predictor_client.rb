require 'net/http'
require 'rack/utils'
require 'uri'

API_URL = 'https://predictor.yandex.net/api/v1/predict.json/complete'.freeze

class YandexPredictorClient
  def fetch_prediction(query)
    url = build_url(query)
    Net::HTTP.get(URI(url))
  end

  private

  def build_url(query)
    query_string = Rack::Utils.build_query(query)

    "#{API_URL}?#{query_string}"
  end
end
