module Restfulie
  module Client
    module HTTP#:nodoc:
      #Client errors
      module Error
      # Standard error thrown on major client exceptions
        class RESTError < StandardError
          attr_reader :response
          attr_reader :request
  
          def initialize(request, response)
            @request  = request
            @response = response
          end
  
          def to_s
            "HTTP error #{@response.code} when invoking #{@request.host} via #{@response.method}. " +
              ((@response.body.blank?) ? "No additional data was sent." : "The complete response was:\n" + @response.body)
          rescue
            super
          end
        end
  
        class AutoFollowWithoutLocationError < RESTError; end
        
        # Represents the HTTP code 503
        class ServerNotAvailableError < RESTError
          def initialize(request, response, exception)
            super(request, response)
            set_backtrace(exception.backtrace)
          end
        end
  
        class UnknownError < RESTError;  end
  
        # Represents the HTTP code 300 range
        class Redirection < RESTError; end 
  
        class ClientError < RESTError; end
  
        # Represents the HTTP code 400
        class BadRequest < ClientError; end 
  
        # Represents the HTTP code 401
        class Unauthorized < ClientError; end 
  
        # Represents the HTTP code 403
        class Forbidden < ClientError; end 
  
        # Represents the HTTP code 404
        class NotFound < ClientError; end 
  
        # Represents the HTTP code 405
        class MethodNotAllowed < ClientError; end 
  
        # Represents the HTTP code 412
        class PreconditionFailed < ClientError; end 
  
        # Represents the HTTP code 407
        class ProxyAuthenticationRequired < ClientError; end 
  
        # Represents the HTTP code 409
        class Conflict < ClientError; end 
  
        # Represents the HTTP code 410
        class Gone < ClientError; end 
  
        # Represents the HTTP code 500
        class ServerError < RESTError; end 
  
        # Represents the HTTP code 501
        class NotImplemented < ServerError; end 
      end
    end
  end
end

