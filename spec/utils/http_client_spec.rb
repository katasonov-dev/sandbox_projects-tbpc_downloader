require_relative '../../utils/http_client'
require 'faraday'

RSpec.describe HttpClient do
  subject(:http_client) { described_class.instance }

  describe '#get' do
    let(:url) { 'https://example.com' }
    let(:connection) { instance_double(Faraday::Connection) }

    before do
      allow(http_client).to receive(:connection).and_return(connection)
    end

    it 'sends a get request using the connection' do
      expect(connection).to receive(:get).with(url)

      http_client.get(url)
    end
  end

  describe 'singleton behavior' do
    it 'returns the same instance' do
      instance1 = described_class.instance
      instance2 = described_class.instance

      expect(instance1).to be(instance2)
    end
  end
end
