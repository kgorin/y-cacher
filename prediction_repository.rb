require './prediction'

class PredictionRepository
  def initialize(client, cache)
    @client = client
    @cache = cache
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
