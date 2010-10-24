module Restfulie
  module Client
    module Mikyung
      Dir["#{File.dirname(__FILE__)}/mikyung/*.rb"].each {|f| autoload File.basename(f)[0..-4].camelize.to_sym, f }
    end
  end
end

# Restfulie::Mikyung entry point is based on its core
# implementation.
module Restfulie
  class Mikyung < Restfulie::Client::Mikyung::Core
    Restfulie::Common::Logger.logger.level = Logger::INFO
  end
end
