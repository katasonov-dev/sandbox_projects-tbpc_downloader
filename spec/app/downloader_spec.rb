require_relative '../../app/downloader'
require_relative '../../app/downloaders/image_downloader'

RSpec.describe Downloader do
  let(:urls) { %w(https://example1.com https://example2.com) }
  let(:child_downloader_class) { Downloaders::ImageDownloader }
  let(:subject_instance) { Downloader.new(urls: urls, downloader: child_downloader_class) }

  describe '#perform' do
    context 'without erorrs' do
      before do
        allow(child_downloader_class).to receive(:perform)
        subject_instance.perform
      end

      it 'delegates perform method to the child class' do
        expect(child_downloader_class).to have_received(:perform).with(urls: urls)
      end
    end

    context 'with errors' do
      let(:exception) { StandardError }
      let(:logger_instance) { AppLogger.instance }

      before do
        allow(logger_instance).to receive(:log)
        allow(child_downloader_class).to receive(:perform).and_raise(exception)
        subject_instance.perform
      end

      it 'raises exception and logs the error' do
        expect(logger_instance).to have_received(:log).with(message_type: :error, message: exception)
      end
    end
  end
end
