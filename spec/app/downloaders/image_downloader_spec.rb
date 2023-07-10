require_relative '../../../app/downloaders/image_downloader'

RSpec.describe Downloaders::ImageDownloader do
  let(:urls) { %w(https://example.com/image1.jpg https://example.com/image2.jpg) }
  let(:http_client) { instance_double(HttpClient) }
  let(:logger) { AppLogger.instance }
  let(:response_body) { 'test_response' }

  describe '.perform' do
    before { allow(HttpClient).to receive(:instance).and_return(http_client) }

    context 'downloads and saves the images from the given URLs' do
      let(:dummy_response) { double('response', body: 'Dummy Image Data', headers: { 'Content-Type' => 'image/jpeg' }) }

      before do
        allow(http_client).to receive(:get).and_return(dummy_response)
        allow(described_class).to receive(:write_file_to_folder)
      end

      it 'saves downloaded files' do
        expect(described_class).to receive(:write_file_to_folder).with(file_data: dummy_response.body, filename: anything)

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
        let(:dummy_response) { double('response', headers: { 'Content-Type' => 'text/html' }, body: 'html_data') }

        before do
          allow(http_client).to receive(:get).and_return(dummy_response)
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
