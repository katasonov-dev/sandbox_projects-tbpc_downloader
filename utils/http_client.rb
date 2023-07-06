require 'singleton'

class HttpClient
  include Singleton

  attr_reader :connection

  def initialize
    @connection = build_connection
  end

  def get(url)
    connection.get(url)
  end

  private

  def build_connection
    Faraday.new do |faraday|
      faraday.adapter Faraday.default_adapter
    end
  end
end

