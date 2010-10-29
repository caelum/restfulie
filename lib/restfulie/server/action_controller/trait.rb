module Restfulie
  module Server
    module ActionController #:nodoc:
      module Trait #:nodoc:
        Dir["#{File.dirname(__FILE__)}/trait/*.rb"].each {|f| autoload File.basename(f)[0..-4].camelize.to_sym, f }
      end
    end
  end
end
