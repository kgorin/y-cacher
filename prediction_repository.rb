require './prediction'
require './cache'
require './yandex_predictor_client'

class PredictionRepository
  def initialize(client = nil, cache = nil)
    @client = client
    @cache = cache
    set_defaults
  end

  def set_defaults
    @client ||= YandexPredictorClient.new
    @cache ||= Cache.new
  end

  def get_prediction(query)
    cached = @cache.get(query)
    if cached
      Prediction.new(cached)
    else
      fetched_prediction(query)
    end
  end

  private

  def fetched_prediction(query)
    raw_prediction = @client.fetch_prediction(query)
    prediction = Prediction.new(raw_prediction)

    @cache.set(query, prediction.raw) if prediction.valid?

    prediction
  end
end
