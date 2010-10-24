module Restfulie
  module Client
    module HTTP#:nodoc:
      Dir["#{File.dirname(__FILE__)}/http/*.rb"].each {|f| autoload File.basename(f)[0..-4].camelize.to_sym, f }
    end
  end
end
