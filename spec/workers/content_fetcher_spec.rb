require 'rspec'
require 'sidekiq'
require_relative '../../workers/content_fetcher'

RSpec.describe Workers::ContentFetcher do
  describe '#perform' do
    let(:file_path) { 'path/to/file.txt' }
    let(:downloader_class) { 'Downloaders::ImageDownloader' }
    let(:urls) { ['https://example.com/image1.jpg', 'https://example.com/image2.jpg'] }

    before do
      allow(URL::Extractor).to receive(:extract_from_file).with(file_path: file_path).and_return(urls)
    end

    context 'when there are valid URLs in the file' do
      let(:downloader) { instance_double('Downloader') }

      it 'calls Downloader.perform with the extracted URLs' do
        expect(Downloader).to receive(:new).with(downloader: Downloaders::ImageDownloader, urls: urls).and_return(downloader)
        expect(downloader).to receive(:perform)

        subject.perform(file_path, downloader_class)
      end
    end

    context 'when there are no valid URLs in the file' do
      let(:empty_urls) { [] }

      before do
        allow(URL::Extractor).to receive(:extract_from_file).with(file_path: file_path).and_return(empty_urls)
      end

      it 'prints a message to the console' do
        expect { subject.perform(file_path, downloader_class) }.to output("There are no valid URLs in the file you provided; Check log.txt for more information\n").to_stdout
      end
    end
  end
end
