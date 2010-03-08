module Restfulie::Client::HTTP

    module Error

      class BaseError < StandardError; end

      class TranslationError < BaseError; end

      # Standard error thrown on major client exceptions
      class RESTError < StandardError

        attr_reader :response
        attr_reader :request

        def initialize(request, response)
          @request  = request
          @response = response
        end

        def to_s
          "HTTP error #{@response.code} when invoking #{@request.host}#{::URI.decode(@response.path)} via #{@response.method}. " +
            ((@response.body.blank?) ? "No additional data was sent." : "The complete response was:\n" + @response.body)
        end

      end

      class ServerNotAvailableError < RESTError
        def initialize(request, response, exception)
          super(request, response)
          set_backtrace(exception.backtrace)
        end
      end

      class UnknownError < RESTError;  end

      # 300 range
      class Redirection < RESTError; end 

      class ClientError < RESTError; end

      # 400
      class BadRequest < ClientError; end 

      # 401
      class Unauthorized < ClientError; end 

      # 403
      class Forbidden < ClientError; end 

      # 404
      class NotFound < ClientError; end 

      # 405
      class MethodNotAllowed < ClientError; end 

      # 412
      class PreconditionFailed < ClientError; end 

      # 407
      class ProxyAuthenticationRequired < ClientError; end 

      # 409
      class Conflict < ClientError; end 

      # 410
      class Gone < ClientError; end 

      # 500
      class ServerError < RESTError; end 

      # 501
      class NotImplemented < ServerError; end 
    end
end

