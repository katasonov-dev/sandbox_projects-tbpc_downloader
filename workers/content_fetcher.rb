require 'sidekiq'

require_relative '../utils/url/extractor'
require_relative '../app/downloader'
require_relative '../app/downloaders/image_downloader'

module Workers
  class ContentFetcher
    include Sidekiq::Worker

    def perform(file_path, downloader_class)
      urls = URL::Extractor.extract_from_file(file_path: file_path)
      if urls.any?
        Downloader.new(downloader: Object.const_get(downloader_class), urls: urls).perform
      else
        puts "There are no valid URLs in the file you provided; Check log.txt for more information"
      end
    end
  end
end
