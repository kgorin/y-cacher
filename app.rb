require 'sinatra'
require './cache'

require "better_errors" if development?
require "sinatra/reloader" if development?
require 'colorize' if development?
require 'pry' if development?

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

get '/' do
  api_key = params[:key]
  query = params[:q]

  content_type :json

  return {}.to_json if api_key.nil? || query.nil?

  begin
    return Cache.get(api_key, query).to_json
  rescue YandexError => e
    return {
      error: e.class,
      message: e
    }.to_json
  end


end
