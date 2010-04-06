module Restfulie
  module Server
    module ActionController
      class ParamsParser
        # This class is just a proxy for the extension point offered by ActionController::Base
        @@param_parsers = ::ActionController::Base.param_parsers

        ## 
        # :singleton-method:
        # Use it to register param parsers on the server side.
        #
        # * <tt>media type</tt>
        # * <tt>a restfulie representation with to_hash method</tt>
        #
        #   Restfulie::Server::ActionController::ParamsParser.register('application/atom+xml', Atom)
        #
        def self.register(content_type, representation)
          @@param_parsers[Mime::Type.lookup(content_type)] = representation.method(:to_hash).to_proc
        end
      end
    end
  end
end

Restfulie::Server::ActionController::ParamsParser.register('application/atom+xml', Restfulie::Common::Representation::Atom)

