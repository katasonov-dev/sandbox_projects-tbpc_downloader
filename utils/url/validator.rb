require 'uri'
require_relative '../../utils/app_logger'

module URL
  class Validator
    def self.valid?(url:)
      uri = URI.parse(url)

      return true if uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)

      AppLogger.instance.log(message_type: :error, message: "URL: #{url} is invalid")
    rescue URI::InvalidURIError => e
      AppLogger.instance.log(message_type: :error, message: e)
      false
    end
  end
end
