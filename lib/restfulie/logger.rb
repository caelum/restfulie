module Restfulie 

  # Configure the logger used by Restfulie
  # 
  # The logger defaults to ActiveSupport::BufferedLogger.new(STDOUT)
  class << self
    attr_accessor :logger
  end

end

Restfulie.logger = ActiveSupport::BufferedLogger.new(STDOUT)
Restfulie.logger.level = Logger::DEBUG
