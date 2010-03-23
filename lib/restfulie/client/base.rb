module Restfulie
  
  # Shortcut to Restfulie::Client::EntryPoint.at
  def self.at(*args)
    Restfulie::Client::EntryPoint.at(*args)
  end
end

module Restfulie::Client#:nodoc

  module EntryPoint#:nodoc:
    include HTTP::Marshal::RequestBuilder
    extend self
  end

  module Base#:nodoc:

    def self.included(base)#:nodoc
      base.extend(ClassMethods)
    end

    module ClassMethods
      include HTTP::Marshal::RequestBuilder

      attr_accessor :config
      
      #Class method to create a Configuration 
      def uses_restfulie(cnf = Configuration.new)
        @config = cnf
        yield cnf
        at(config.entry_point)
      end

      def request!(method, path, *args)#:nodoc
        if config.default_headers and config.default_headers[method]
          if self.default_headers
            self.default_headers = config.default_headers[method].dup.merge!( self.default_headers ) 
          else 
            self.default_headers = config.default_headers[method]
          end
        end
        super
      end

    end

  end

end

