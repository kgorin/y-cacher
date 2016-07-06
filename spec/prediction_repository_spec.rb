require './prediction_repository'
require './yandex_predictor_client'
require './cache'

RSpec.describe PredictionRepository do
  let(:query) { 'test query string' }

  let(:raw_prediction) {
    '{"endOfWord":true,"pos":1,"text":["to","is","and"]}'
  }

  let(:prediction) {
    {
      'endOfWord' => true,
      'pos' => 1,
      'text' => [
        'to',
        'is',
        'and'
      ]
    }
  }

  context 'query is cached' do
    before do
      @cache = Cache.new
      allow(@cache).to receive(:get).and_return(raw_prediction)

      @client = YandexPredictorClient.new
    end

    it 'returns prediction correctly' do
      prediction = PredictionRepository.new(@client, @cache).get_prediction(query)
      expect(prediction.raw).to eq(raw_prediction)
    end

    it "doesn't hit API" do
      expect(@client).not_to receive(:fetch_prediction)
      PredictionRepository.new(@client, @cache).get_prediction(query)
    end
  end

  context 'query is not cached' do
    before do
      @cache = Cache.new
      allow(@cache).to receive(:get).and_return(nil)

      @client = YandexPredictorClient.new
      allow(@client).to receive(:fetch_prediction).and_return(raw_prediction)
    end

    it 'returns prediction correctly' do
      prediction = PredictionRepository.new(@client, @cache).get_prediction(query)
      expect(prediction.raw).to eq(raw_prediction)
    end

    it 'hits API' do
      expect(@client).to receive(:fetch_prediction).once
      PredictionRepository.new(@client, @cache).get_prediction(query)
    end
  end
end
