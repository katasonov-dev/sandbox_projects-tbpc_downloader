require_relative '../../../utils/url/validator'

RSpec.describe URL::Validator do
  describe '.valid?' do
    let(:valid_url) { 'https://example1.com' }
    let(:invalid_url) { 'im_not_@_url' }
    let(:logger) { AppLogger.instance }

    before { allow(logger).to receive(:log) }

    context 'with valid url' do
      it 'is true' do
        expect(described_class.valid?(url: valid_url)).to be(true)
      end
    end

    context 'with invalid url' do
      it 'is false' do
        expect(described_class.valid?(url: invalid_url)).to be(false)
      end
    end

    context 'with error' do
      before do
        allow(logger).to receive(:log)
        described_class.valid?(url: nil)
      end

      it 'logs the error' do
        expect(logger).to have_received(:log)
      end
    end
  end
end
