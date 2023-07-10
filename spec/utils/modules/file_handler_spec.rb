require 'date'

require_relative '../../../utils/modules/file_handler'

RSpec.describe FileHandler do
  let(:dummy_class) { Class.new { include FileHandler } }
  let(:dummy_object) { dummy_class.new }
  let(:date_today_string) { Date.today.to_s }

  describe '#destination_folder' do
    let(:default_folder_path) { FileHandler::DEFAULT_DOWNLOADS_FOLDER }
    let(:expected_folder_path) { "#{default_folder_path}/#{date_today_string}" }
    let(:folder_path) { dummy_object.destination_folder(create_if_absent: false) }

    it 'returns the correct folder path' do
      expect(dummy_object.destination_folder).to eq(expected_folder_path)
    end

    it 'returns the default folder path when create_if_absent is false' do
      expect(folder_path).to eq(default_folder_path)
    end
  end

  describe '#build_filename' do
    let(:time_now_string) { Time.now.strftime('%s') }

    context 'without extension in URL' do
      let(:expected_filename) { "#{time_now_string}image.jpg" }
      let(:url) { 'https://example.com/image.jpg' }
      let(:response) { double('response', headers: { 'Content-Type' => 'image/jpeg' }) }

      it 'returns the correct filename with extension' do
        expect(dummy_object.build_filename(response: response, url: url)).to eq(expected_filename)
      end
    end

    context 'with extension in URL' do
      let(:expected_filename) { "#{time_now_string}document.pdf" }
      let(:url) { 'https://example.com/document.pdf' }
      let(:response) { double('response', headers: { 'Content-Type' => 'application/pdf' }) }

      it 'returns the correct filename when extension already exists' do
        expect(dummy_object.build_filename(response: response, url: url)).to eq(expected_filename)
      end
    end
  end

  describe '#write_file_to_folder' do
    let(:file_data) { 'This is some file data' }
    let(:filename) { 'test.txt' }
    let(:folder_path) { "downloads/#{date_today_string}" }

    it 'writes the file data to the correct folder with the specified filename' do
      expect(File).to receive(:open).with("#{folder_path}/#{filename}", 'wb').and_yield(double('file').as_null_object)

      dummy_object.write_file_to_folder(file_data: file_data, filename: filename)
    end
  end
end
