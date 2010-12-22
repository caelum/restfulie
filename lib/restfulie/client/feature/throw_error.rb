class Restfulie::Client::Feature::ThrowError
  def execute(flow, request, env)
    result = flow.continue(request, env)
    if result.kind_of? Exception
      Restfulie::Common::Logger.logger.error(result)
      raise Restfulie::Client::HTTP::Error::ServerNotAvailableError.new(request, Restfulie::Client::HTTP::Response.new(request.verb, request.path, 503, nil, {}), result )
    end
    case result.response.code.to_i
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