require_relative 'utils/url/extractor'
require_relative 'workers/image_downloader'

namespace :download do
  task :images, [:file_path] do |_, args|
    urls = URL::Extractor.extract_from_file(file_path: args[:file_path])
    if urls.any?
      Workers::ImageDownloader.perform_async(urls)
    else
      puts "There are no valid URLs in the file you provided; Check log.txt for more information"
    end
  end
end
