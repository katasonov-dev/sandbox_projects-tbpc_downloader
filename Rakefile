require_relative 'workers/content_fetcher'

namespace :download do
  task :images, [:file_path] do |_, args|
    Workers::ContentFetcher.perform_async(args[:file_path], 'Downloaders::ImageDownloader')
  end
end
