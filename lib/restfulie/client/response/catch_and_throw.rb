module Restfulie
  module Client
    module Response
      class CatchAndThrow
        def parse(host, path, http_request, request, response)
          case response.code
          when 100..299
            response
          when 300..399
            raise Error::Redirection.new(request, response)
          when 400
            raise Error::BadRequest.new(request, response)
          when 401
            raise Error::Unauthorized.new(request, response)
          when 403
            raise Error::Forbidden.new(request, response)
          when 404
            raise Error::NotFound.new(request, response)
          when 405
            raise Error::MethodNotAllowed.new(request, response)
          when 407
            raise Error::ProxyAuthenticationRequired.new(request, response)
          when 409
            raise Error::Conflict.new(request, response)
          when 410
            raise Error::Gone.new(request, response)
          when 412
            raise Error::PreconditionFailed.new(request, response)
          when 402, 406, 408, 411, 413..499
            raise Error::ClientError.new(request, response)
          when 501
            raise Error::NotImplemented.new(request, response)
          when 500, 502..599
            raise Error::ServerError.new(request, response)
          else
            raise Error::UnknownError.new(request, response)
          end
        end

      end
    end
  end
end