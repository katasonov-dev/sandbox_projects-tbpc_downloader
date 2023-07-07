require_relative '../../../utils/url/extractor'

RSpec.describe URL::Extractor do
  describe '.extract_from_file' do
    let(:valid_urls) { %w(https://example1.com http://example2.com https://example3.com http://example4.com) }
    let(:invalid_urls) { %w(im_not_@_url ?and_me_too!) }
    let(:file_path) { File.join(File.dirname(__FILE__), '../../support/valid_image_urls.txt') }

    before { allow(AppLogger.instance).to receive(:log) }

    context 'with valid urls' do
      it 'returns valid urls' do
        expect(described_class.extract_from_file(file_path: file_path)).to eq(valid_urls)
      end
    end

    context 'with valid and invalid urls' do
      let(:file_path) { File.join(File.dirname(__FILE__), '../../support/different_image_urls.txt') }

      it 'returns only valid urls' do
        expect(described_class.extract_from_file(file_path: file_path)).to eq(valid_urls)
      end
    end

    context 'with invalid image urls' do
      let(:file_path) { File.join(File.dirname(__FILE__), '../../support/invalid_image_urls.txt') }

      it 'returns empty array' do
        expect(described_class.extract_from_file(file_path: file_path)).to eq([])
      end
    end
  end
end
