require 'uri'
require 'logger'

class URLValidator
  def self.valid?(url)
    uri = URI.parse(url)
    return true if uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)

    #log error
  rescue URI::InvalidURIError => e
    # log error
    false
  end
end
