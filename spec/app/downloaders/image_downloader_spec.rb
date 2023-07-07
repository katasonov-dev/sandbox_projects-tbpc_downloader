require_relative '../../../app/downloaders/image_downloader'

RSpec.describe Downloaders::ImageDownloader do
  let(:urls) { %w(https://example.com/image1.jpg https://example.com/image2.jpg) }
  let(:http_client) { instance_double(HttpClient) }
  let(:logger) { AppLogger.instance }
  let(:response_body) { 'test_response' }

  describe '.perform' do
    before { allow(HttpClient).to receive(:instance).and_return(http_client) }

    context 'downloads and saves the images from the given URLs' do
      before do
        allow(http_client).to receive(:get).and_return(double(headers: { 'Content-Type' => 'image/jpeg' }, body: 'image_data'))
        allow(FileUtils).to receive(:mkdir_p)
        allow(File).to receive(:open)
      end

      it 'saves downloaded files' do
        expect(File).to receive(:open).with(match(%r{downloads/[\d-]+/images}), "wb")

        described_class.perform(urls: urls)
      end
    end

    context 'with errors' do
      context 'logs an error for failed HTTP requests' do
        before do
          allow(http_client).to receive(:get).and_raise(Faraday::TimeoutError)
          allow(logger).to receive(:log)
          described_class.perform(urls: urls)
        end

        it 'logs an error' do
          expect(logger).to have_received(:log)
            .with(message_type: :error, message: /An error occurred while requested url: https:\/\/example.com\/image\d\.jpg/)
            .exactly(urls.size).times
        end
      end

      context 'logs an error for non-image URLs' do
        before do
          allow(http_client).to receive(:get).and_return(double(headers: { 'Content-Type' => 'text/html' }, body: 'html_data'))
          allow(logger).to receive(:log)
          described_class.perform(urls: urls)
        end

        it 'logs an error' do
          expect(logger).to have_received(:log)
            .with(message_type: :error, message: /File with url: https:\/\/example.com\/image\d\.jpg is not an image/)
            .exactly(urls.size).times
        end
      end
    end
  end
end
