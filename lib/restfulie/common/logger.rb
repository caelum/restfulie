module Restfulie::Common::Logger
  # Configure the logger used by Restfulie
  # 
  # The logger defaults to ActiveSupport::BufferedLogger.new(STDOUT)
  class << self
    attr_accessor :logger
  end
end

Restfulie::Common::Logger.logger = ActiveSupport::BufferedLogger.new(STDOUT)
Restfulie::Common::Logger.logger.level = Logger::DEBUG
