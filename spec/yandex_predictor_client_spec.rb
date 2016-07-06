require './yandex_predictor_client'

RSpec.describe YandexPredictorClient do
  describe '#fetch_prediction' do
    let(:query) {
      {
        'key' => 'api_key',
        'q' => 'test query string',
        'lang' => 'en',
        'limit' => 3
      }
    }
    let(:correct_response) {
      '{"endOfWord":true,"pos":1,"text":["to","is","and"]}'
    }

    it 'returns a valid prediction' do
      response = YandexPredictorClient.new.fetch_prediction(query)

      expect(response).to eq(correct_response)
    end
  end
end
