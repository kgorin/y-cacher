require './prediction'

RSpec.describe Prediction do
  let(:valid_raw) { '{"endOfWord":true,"pos":1,"text":["blah","and","to"]}' }

  describe '#valid?' do
    let(:invalid_raw) { '{"code":401,"message":"API key is invalid"}' }

    it 'returns true when there is no errors' do
      prediction = Prediction.new(valid_raw)
      expect(prediction).to be_valid
    end

    it 'returns false when there are errors' do
      prediction = Prediction.new(invalid_raw)
      expect(prediction).to_not be_valid
    end
  end
end
