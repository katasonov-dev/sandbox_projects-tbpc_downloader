require 'singleton'
require 'logger'

class AppLogger
  include Singleton

  attr_reader :logger
  
  def initialize
    @logger = Logger.new('log.txt')
  end

  def log(message_type:, message:)
    logger.send(message_type, message)
  end
end
