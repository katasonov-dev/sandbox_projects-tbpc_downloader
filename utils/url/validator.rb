require 'uri'
require 'pry'
require_relative '../../utils/app_logger'

module URL
  class Validator
    def self.valid?(url:)
      uri = URI.parse(url)

      if uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
        true
      else
        AppLogger.instance.log(message_type: :error, message: "URL: #{url} is invalid")
        false
      end
    rescue URI::InvalidURIError => e
      AppLogger.instance.log(message_type: :error, message: e)
      false
    end
  end
end
