module Restfulie 
  module Logger
    # Configure the logger used by Restfulie
    # 
    # The logger defaults to ActiveSupport::BufferedLogger.new(STDOUT)
    class << self
      attr_accessor :logger
    end
  end
end

Restfulie::Logger.logger = ActiveSupport::BufferedLogger.new(STDOUT)
Restfulie::Logger.logger.level = Logger::DEBUG
