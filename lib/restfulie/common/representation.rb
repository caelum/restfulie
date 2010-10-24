module Restfulie::Common::Representation
  Dir["#{File.dirname(__FILE__)}/representation/*.rb"].each {|f| autoload File.basename(f)[0..-4].camelize.to_sym, f }
end
