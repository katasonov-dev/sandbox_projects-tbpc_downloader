class Downloader
  attr_reader :downloader, :urls

  def initialize(downloader:, urls: [])
    @downloader = downloader
    @urls = urls
  end

  def download
    downloader.download(urls: urls)
  end
end
