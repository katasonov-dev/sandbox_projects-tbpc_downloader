require_relative 'validator'
require_relative '../../utils/app_logger'

module URL
  class Extractor
    def self.extract_from_file(file_path:)
      unvalidated_urls = File.open(file_path, 'r') do |file|
        urls = file.read
        urls.split(/[, \n\t]+/)
      end

      validated_urls = unvalidated_urls.map { |url| url if URL::Validator.valid?(url: url) }

      if validated_urls.empty?
        AppLogger.instance.log(
          message_type: :info,
          message: "File doesn't contain valid urls or filled out incorrectly"
        )
        return []
      end

      validated_urls.uniq.compact
    end
  end
end
