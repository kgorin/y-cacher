require './cache'

RSpec.describe Cache do
  subject { Cache.new }
  before do
    subject.redis.flushall
  end

  describe '#get' do
    let(:key) { 'test_key' }
    let(:value) { 'test value' }

    context 'key exists' do
      before do
        subject.set(key, value)
      end

      it 'returns correct value' do
        expect(subject.get(key)).to eq(value)
      end
    end

    context "key doesn't exists" do
      it 'returns nil' do
        expect(subject.get(key)).to be_nil
      end
    end
  end

  describe '#set' do
    let(:key) { 'test_key' }
    let(:value) { 'test value' }

    it 'sets key correctly' do
      subject.set(key, value)

      expect(subject.get(key)).to eq(value)
    end
  end
end
