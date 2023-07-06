require_relative '../utils/app_logger'

class Downloader
  attr_accessor :downloader, :urls

  def initialize(downloader:, urls: [])
    @downloader = downloader
    @urls = urls
  end

  def perform
    downloader.perform(urls: urls)
  rescue StandardError => e
    AppLogger.instance.log(message_type: :error, message: e)
  end
end
