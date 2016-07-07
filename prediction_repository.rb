require './prediction'
require './cache'
require './yandex_predictor_client'

class PredictionRepository
  def initialize
    @client = YandexPredictorClient.new
    @cache = Cache.new
  end

  def get_prediction(query)
    cached = @cache.get(query)
    return Prediction.new(cached) if cached

    raw_prediction = @client.fetch_prediction(query)
    prediction = Prediction.new(raw_prediction)

    @cache.set(query, prediction.raw) if prediction.valid?

    prediction
  end
end
