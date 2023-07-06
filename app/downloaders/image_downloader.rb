require 'faraday'
require 'logger'

module Downloaders
  class ImageDownloader
    class << self

      def download(urls: [])
        urls.each do |url|
          begin
            response = http_client.get(url)
          rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
            logger.error("An error occured while requested url: #{url}. #{e.class}")
            next
          end

          if response_contents_image?(response)
            filename = File.basename(url)
            write_file_to_folder(file_data: response.body, filename: filename)
          else
            logger.error("File with url: #{url} is not an image")
          end
        end
      rescue StandardError => e
        logger.error(e)
      end

      private

      def http_client
        @http_client ||= Faraday.new(request: { timeout: 10 })
      end

      def logger
        @logger ||= Logger.new(File.join(destination_folder, 'log.txt'))
      end

      def destination_folder
        folder_path = "downloads/#{Date.today.to_s}/images"

        FileUtils.mkdir_p(folder_path) unless File.directory?(folder_path)
        folder_path
      end

      def response_contents_image?(response)
        content_type = response.headers['Content-Type']
        content_type && content_type.start_with?('image/')
      end

      def write_file_to_folder(file_data:, filename:)
        file_path = File.join(destination_folder, filename)

        File.open(file_path, 'wb') do |file|
          file.write(file_data)
        end
      end
    end
  end
end
