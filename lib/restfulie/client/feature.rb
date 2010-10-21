module Restfulie::Client
  module Feature
    autoload :EnhanceResponse, 'restfulie/client/feature/enhance_response'
    autoload :Base, 'restfulie/client/feature/base'
    autoload :Verb, 'restfulie/client/feature/verb'
  end
end

module Restfulie::Client::Feature

  class BaseRequest
    
    def execute(flow, request, response)
      request!(request.verb, request.host, request.path, request, flow)
    end
    
    # Executes a request against your server and return a response instance.
    # * <tt>method: :get,:post,:delete,:head,:put</tt>
    # * <tt>path: '/posts'</tt>
    # * <tt>args: payload: 'some text' and/or headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
    def request!(method, host, path, request, flow, *args)
      headers = request.default_headers.merge(args.extract_options!)
      unless host.user.blank? && host.password.blank?
        headers["Authorization"] = "Basic " + ["#{host.user}:#{host.password}"].pack("m").delete("\r\n")
      end
      headers.delete :recipe
      headers['cookie'] = request.cookies if request.cookies
      args << headers

      ::Restfulie::Common::Logger.logger.info(request.http_to_s(method, path, *args)) if ::Restfulie::Common::Logger.logger
      begin
        http_request = get_connection_provider(host)

        cached = Restfulie::Client.cache_provider.get([host, path], http_request, method)
        return cached if cached

        response = http_request.send(method, path, *args)
      rescue Exception => e
        response = e
      end
      
      flow.continue(request, response)
      
      # Restfulie::Client::Response::EnhanceResponse.new(response_handler).parse(host, path, http_request, self, response, method)

    end

    # Executes a request against your server and return a response instance without {Error}
    # * <tt>method: :get,:post,:delete,:head,:put</tt>
    # * <tt>path: '/posts'</tt>
    # * <tt>args: payload: 'some text' and/or headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
    def request(method = nil, path = nil, *args)
      @response_handler = Restfulie::Client::Response::IgnoreError.new(@response_handler)
      request!(method, path, *args) 
    end

    def get_connection_provider(host)
      @connection ||= ::Net::HTTP.new(host.host, host.port)
    end
    
  end
  
end