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
        
        ## 
        # :singleton-method:
        # Use it to unregister param parsers on the server side.
        #
        # * <tt>media type</tt>
        #
        #   Restfulie::Server::ActionController::ParamsParser.unregister('application/atom+xml')
        #
        def self.unregister(content_type)
          @@param_parsers.delete(Mime::Type.lookup(content_type))
        end
      end
    end
  end
end

# This monkey patch is needed because Rails 2.3.5 doesn't support
# a way of use rescue_from ActionController handling to return
# bad request status when trying to parse an invalid body request
#
# In Rails 3 this won't be necessary, because all exception handling
# extensions are handled by the Rack stack
#
# TODO Change this when porting this code to Rails 3
# ::ActionController::ParamsParser.class_eval do
#   def call(env)
#     begin
#       if params = parse_formatted_parameters(env)
#         env["action_controller.request.request_parameters"] = params
#       else
#        return [415, {'Content-Type' => 'text/html'}, "<html><body><h1>415 Unsupported Media Type</h1></body></html>"]
#       end
#     rescue
#       return [400, {'Content-Type' => 'text/html'}, "<html><body><h1>400 Bad Request</h1></body></html>"]
#     end
# 
#     @app.call(env)
#   end
# end

# Atom representation is added by default
Restfulie::Server::ActionController::ParamsParser.register('application/atom+xml', Restfulie::Common::Representation::Atom)

