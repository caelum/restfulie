class Restfulie::Client::Feature::BaseRequest
  
  def execute(flow, request, response, env)
    request!(request.verb, request.host, request.path, request, flow, env)
  end
  
  # Executes a request against your server and return a response instance.
  # * <tt>method: :get,:post,:delete,:head,:put</tt>
  # * <tt>path: '/posts'</tt>
  # * <tt>args: payload: 'some text' and/or headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
  def request!(method, host, path, request, flow, env)

    ::Restfulie::Common::Logger.logger.info(request.http_to_s(method, path, [request.headers])) if ::Restfulie::Common::Logger.logger
    begin
      http_request = get_connection_provider(host)

      if env[:body]
        response = http_request.send(method, path, env[:body], request.headers)
      else
        response = http_request.send(method, path, request.headers)
      end

    rescue Exception => e
      response = e
    end
    
    flow.continue(request, response, env)
    
  end

  def get_connection_provider(host)
    @connection ||= ::Net::HTTP.new(host.host, host.port)
  end
  
end
