module Restfulie
  module Client
    module Response
      class CatchAndThrow
        def parse(host, path, http_request, request, response, method)
          if response.kind_of? Exception
            Restfulie::Common::Logger.logger.error(response)
            raise Restfulie::Client::HTTP::Error::ServerNotAvailableError.new(request, Response.new(method, path, 503, nil, {}), response )
          end
          case response.code
          when 100..299
            response
          when 300..399
            raise Restfulie::Client::HTTP::Error::Redirection.new(request, response)
          when 400
            raise Restfulie::Client::HTTP::Error::BadRequest.new(request, response)
          when 401
            raise Restfulie::Client::HTTP::Error::Unauthorized.new(request, response)
          when 403
            raise Restfulie::Client::HTTP::Error::Forbidden.new(request, response)
          when 404
            raise Restfulie::Client::HTTP::Error::NotFound.new(request, response)
          when 405
            raise Restfulie::Client::HTTP::Error::MethodNotAllowed.new(request, response)
          when 407
            raise Restfulie::Client::HTTP::Error::ProxyAuthenticationRequired.new(request, response)
          when 409
            raise Restfulie::Client::HTTP::Error::Conflict.new(request, response)
          when 410
            raise Restfulie::Client::HTTP::Error::Gone.new(request, response)
          when 412
            raise Restfulie::Client::HTTP::Error::PreconditionFailed.new(request, response)
          when 402, 406, 408, 411, 413..499
            raise Restfulie::Client::HTTP::Error::ClientError.new(request, response)
          when 501
            raise Restfulie::Client::HTTP::Error::NotImplemented.new(request, response)
          when 500, 502..599
            raise Restfulie::Client::HTTP::Error::ServerError.new(request, response)
          else
            raise Restfulie::Client::HTTP::Error::UnknownError.new(request, response)
          end
        end

      end
    end
  end
end