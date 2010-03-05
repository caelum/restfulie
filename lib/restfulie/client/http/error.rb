module Restfulie::Client::HTTP

    module Error

      class BaseError < StandardError; end

      class TranslationError < BaseError; end

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

      class Redirection < RESTError; end

      class ClientError < RESTError; end

      class BadRequest < ClientError; end

      class Unauthorized < ClientError; end

      class Forbidden < ClientError; end

      class NotFound < ClientError; end

      class MethodNotAllowed < ClientError; end

      class PreconditionFailed < ClientError; end

      class ProxyAuthenticationRequired < ClientError; end

      class Conflict < ClientError; end

      class Gone < ClientError; end

      class ServerError < RESTError; end

      class NotImplemented < ServerError; end

    end

end

