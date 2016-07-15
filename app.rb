require 'sinatra'
require './prediction_repository'

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

set :protection, true
set :protect_from_csrf, true
set :allow_disabled_csrf, true

PERMITTED_PARAMS = %w(key q lang limit).freeze
EMPTY_JSON = '{}'

get '/' do
  query_params = params.select { |k, _| PERMITTED_PARAMS.include?(k) }

  content_type :json
  return EMPTY_JSON if query_params['key'].nil? || query_params['q'].nil?

  repository = PredictionRepository.new
  prediction = repository.get_prediction(query_params)

  if prediction.valid?
    return prediction.raw
  else
    status 422
    "Invalid request"
  end
end
