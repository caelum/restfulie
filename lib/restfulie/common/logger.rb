module Restfulie
  module Common
    class Logger
      # Configure the logger used by Restfulie
      # 
      # The logger defaults to ActiveSupport::BufferedLogger.new(STDOUT)
      def self.logger
        @@logger
      end

      def self.logger=(value)
        @@logger = value
      end

      @@logger = ActiveSupport::BufferedLogger.new(STDOUT)
      @@logger.level = ::Logger::DEBUG
    end
  end
end
