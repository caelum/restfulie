# Adds support to throwing an error when 300+ response codes are returned
#
# To use it, load it in your dsl:
# Restfulie.at("http://localhost:3000/product/2").throw_error.get
class Restfulie::Client::Feature::ThrowErrorRequest
  def execute(flow, request, env)
    result = flow.continue(request, env)
    if result.kind_of? Exception
      Restfulie::Common::Logger.logger.error(result)
      response = Restfulie::Client::Feature::FakeResponse.new(503, "")
      raise Restfulie::Client::HTTP::Error::ServerNotAvailableError.new(request, response, result )
    end
    case result.response.code
    when 100..299
      result
    when 300..399
      raise Restfulie::Client::HTTP::Error::Redirection.new(request, result)
    when 400
      raise Restfulie::Client::HTTP::Error::BadRequest.new(request, result)
    when 401
      raise Restfulie::Client::HTTP::Error::Unauthorized.new(request, result)
    when 403
      raise Restfulie::Client::HTTP::Error::Forbidden.new(request, result)
    when 404
      raise Restfulie::Client::HTTP::Error::NotFound.new(request, result)
    when 405
      raise Restfulie::Client::HTTP::Error::MethodNotAllowed.new(request, result)
    when 407
      raise Restfulie::Client::HTTP::Error::ProxyAuthenticationRequired.new(request, result)
    when 409
      raise Restfulie::Client::HTTP::Error::Conflict.new(request, result)
    when 410
      raise Restfulie::Client::HTTP::Error::Gone.new(request, result)
    when 412
      raise Restfulie::Client::HTTP::Error::PreconditionFailed.new(request, result)
    when 402, 406, 408, 411, 413..499
      raise Restfulie::Client::HTTP::Error::ClientError.new(request, result)
    when 501
      raise Restfulie::Client::HTTP::Error::NotImplemented.new(request, result)
    when 500, 502..599
      raise Restfulie::Client::HTTP::Error::ServerError.new(request, result)
    else
      raise Restfulie::Client::HTTP::Error::UnknownError.new(request, result)
    end
  end
end