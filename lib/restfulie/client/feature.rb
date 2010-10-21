module Restfulie::Client
  module Feature
    
    class EnhanceResponse
      def execute(flow, request, response)
        resp = flow.continue(flow, request, response)
        unless resp.kind_of? ::Restfulie::Client::HTTP::ResponseHolder
          resp.extend(::Restfulie::Client::HTTP::ResponseHolder)
          resp.response = response
        end
        resp
      end
    end
    
    module Base
      
      attr_reader :default_headers
      
      def cookies
        @cookies
      end
      
      def verb
        @method
      end
      
      def get
        @method = :get
        request_flow
      end
      
      #Set host
      def at(url)
        if self.host.nil?
          self.host= url
        else
          self.host= self.host + url
        end
        self
      end

      #Set Content-Type and Accept headers
      def as(content_type)
        headers['Content-Type'] = content_type
        accepts(content_type)
      end

      #Set Accept headers
      def accepts(content_type)
        headers['Accept'] = content_type
        self
      end

      # Merge internal header
      #
      # * <tt>headers (e.g. {'Cache-control' => 'no-cache'})</tt>
      #
      def with(headers)
        headers.merge!(headers)
        self
      end

      # Path (e.g. http://restfulie.com/posts => /posts)
      def path
        host.path
      end

      def host
        @host
      end

      def host=(host)
        if host.is_a?(::URI)
          @host = host
        else
          @host = ::URI.parse(host)
        end
      end

      def default_headers
        @default_headers ||= {}
      end

      def headers
        @headers ||= {}
      end

      def http_to_s(method, path, *args)
        result = ["#{method.to_s.upcase} #{path}"]

        arguments = args.dup
        headers = arguments.extract_options!

        if [:post, :put].include?(method)
          body = arguments.shift
        end

        result << headers.collect { |key, value| "#{key}: #{value}" }.join("\n")

        (result + [body ? (body.inspect + "\n") : nil]).compact.join("\n") << "\n"
      end

      protected

      def headers=(h)
        @headers = h
      end

    end
    
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
end