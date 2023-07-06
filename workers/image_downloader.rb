require 'sidekiq'
require_relative '../app/downloader'
require_relative '../app/downloaders/image_downloader'

module Workers
  class ImageDownloader
    include Sidekiq::Worker

    def perform(urls)
      Downloader.new(downloader: Downloaders::ImageDownloader, urls: urls).perform
    end
  end
end
