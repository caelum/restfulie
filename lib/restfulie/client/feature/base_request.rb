class Restfulie::Client::Feature::BaseRequest

  def execute(flow, request, env)
    request!(request.verb, request.host, request.path, request, flow, env)
  end
  
  # Executes a request against your server and return a response instance.
  # * <tt>method: :get,:post,:delete,:head,:put</tt>
  # * <tt>path: '/posts'</tt>
  # * <tt>args: payload: 'some text' and/or headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def request!(method, host, path, request, flow, env)

    ::Restfulie::Common::Logger.logger.info(request.http_to_s(method, path, [request.headers])) if ::Restfulie::Common::Logger.logger
    http_request = get_connection_provider(host, env)

    if env[:body]
      enhance http_request.send(method, path, env[:body], request.headers)
    else
      enhance http_request.send(method, path, request.headers)
    end
    
  end

  protected

  def get_connection_provider(uri, env)
    @connection ||= create_connection(uri, env)
  end

  private
  def create_connection(uri, env)
    result = ::Net::HTTP.new(uri.host, uri.port)
    result.use_ssl = true if uri.scheme == 'https'
    ssl_verify_mode = env[:ssl_verify_mode]
    result.verify_mode = ssl_verify_mode if ssl_verify_mode
    result
  end

  def enhance(response)
    def response.code
      super.to_i
    end
    response
  end
  
end
