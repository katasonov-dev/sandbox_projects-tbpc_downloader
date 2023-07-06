require_relative 'utils/url/extractor'
require_relative 'workers/image_downloader'

namespace :download do
  task :images, [:file_path] do |_, args|
    urls = URL::Extractor.extract_urls(file_path: args[:file_path])
    Workers::ImageDownloader.perform_async(urls)
  end
end
