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

# This monkey patch is needed because Rails 2.3.5 doesn't support
# a way of use rescue_from ActionController handling to return
# bad request status when trying to parse an invalid body request
::ActionController::ParamsParser.class_eval do
  def call(env)
    begin
      if params = parse_formatted_parameters(env)
        env["action_controller.request.request_parameters"] = params
      end
    rescue
      return [400, {'Content-Type' => 'text/html'}, "<html><body><h1>400 Bad Request</h1></body></html>"]
    end

    @app.call(env)
  end
end

Restfulie::Server::ActionController::ParamsParser.register('application/atom+xml', Restfulie::Common::Representation::Atom)

