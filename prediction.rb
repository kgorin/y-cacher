require 'json'

class Prediction
  attr_reader :raw

  def initialize(raw)
    @raw = raw
  end

  def parsed
    @parsed ||= JSON.parse(@raw)
  end

  def valid?
    parsed['code'].nil?
  end
end
