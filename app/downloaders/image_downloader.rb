require 'faraday'

require_relative '../../utils/app_logger'
require_relative '../../utils/http_client'
require_relative '../../utils/modules/file_handler'

module Downloaders
  class ImageDownloader
    extend FileHandler

    class << self
      def perform(urls: [])
        urls.each do |url|
          begin
            response = HttpClient.instance.get(url)
          rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
            AppLogger.instance.log(message_type: :error, message: "An error occurred while requested url: #{url}. #{e.class}")
            next
          end

          if response_contents_image?(response: response)
            write_file_to_folder(file_data: response.body, filename: build_filename(response: response, url: url))
          else
            AppLogger.instance.log(message_type: :error, message: "File with url: #{url} is not an image")
          end
        end
      end

      private

      def response_contents_image?(response:)
        content_type = response.headers['Content-Type']
        content_type && content_type.start_with?('image/')
      end
    end
  end
end
