module Restfulie::Client

  module EntryPoint
    include HTTP::Marshal::RequestBuilder
    extend self
  end

  module Base

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      include HTTP::Marshal::RequestBuilder

      attr_accessor :config

      def uses_restfulie(cnf = Configuration.new)
        @config = cnf
        yield cnf
        at(config.entry_point)
      end

      def request!(method, path, *args)
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

