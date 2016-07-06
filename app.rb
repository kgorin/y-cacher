require 'sinatra'
require './cache'
require './prediction_repository'
require './yandex_predictor_client'

if development?
  require 'better_errors'
  require 'sinatra/reloader'
  require 'colorize'
  require 'pry'
end

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

get '/' do
  query_params = params.select { |k, _| %w(key q lang limit).include?(k) }

  content_type :json
  return {}.to_json if query_params['key'].nil? || query_params['q'].nil?

  begin
    client = YandexPredictorClient.new
    cache = Cache.new
    repository = PredictionRepository.new(client, cache)

    return repository.get_prediction(query_params).raw
  rescue => e
    return {
      error: e.class,
      message: e
    }.to_json
  end
end
