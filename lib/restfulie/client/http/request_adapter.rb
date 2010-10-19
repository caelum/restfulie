module Restfulie
  module Client
    module HTTP #:nodoc:
      # Request Adapter provides a minimal interface to exchange information between server over HTTP protocol through simple adapters.
      # 
      # All the concrete adapters follow the interface laid down in this module.
      # Default connection provider is net/http
      #
      #==Example
      #
      #   @re = ::Restfulie::Client::HTTP::RequestExecutor.new('http://restfulie.com') #this class includes RequestAdapter module.
      #   puts @re.as('application/atom+xml').get!('/posts').title #=> 'Hello World!'
      #
      class RequestAdapter
        
        attr_accessor :cookies, :response_handler
        attr_writer   :default_headers
        
        class CatchAndThrow
          def parse(host, path, http_request, request, response)
            case response.code
            when 100..299
              [[host, path], http_request, response]
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
        
        def initialize
          @response_handler = CatchAndThrow.new
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

        # Executes a request against your server and return a response instance without {Error}
        # * <tt>method: :get,:post,:delete,:head,:put</tt>
        # * <tt>path: '/posts'</tt>
        # * <tt>args: payload: 'some text' and/or headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
        def request(method, path, *args)
          request!(method, path, *args) 
        rescue Error::RESTError => se
          [[@host, path], nil, se.response]
        end

        # Executes a request against your server and return a response instance.
        # * <tt>method: :get,:post,:delete,:head,:put</tt>
        # * <tt>path: '/posts'</tt>
        # * <tt>args: payload: 'some text' and/or headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
        def request!(method, path, *args)
          headers = default_headers.merge(args.extract_options!)
          unless @host.user.blank? && @host.password.blank?
            headers["Authorization"] = "Basic " + ["#{@host.user}:#{@host.password}"].pack("m").delete("\r\n")
          end
          headers['cookie'] = @cookies if @cookies
          args << headers

          ::Restfulie::Common::Logger.logger.info(request_to_s(method, path, *args)) if ::Restfulie::Common::Logger.logger
          begin
            http_request = get_connection_provider
            response = Restfulie::Client.cache_provider.get([@host, path], http_request, method)
            # if response.has_cookie?
            #   default_headers << response.cookies
            # end
            return [[@host, path], http_request, response] if response
            response = http_request.send(method, path, *args)
            response = ResponseHandler.handle(method, path, response)
          rescue Exception => e
            Restfulie::Common::Logger.logger.error(e)
            raise Error::ServerNotAvailableError.new(self, Response.new(method, path, 503, nil, {}), e )
          end
          
          response_handler.parse(@host, path, http_request, self, response)

        end

        private

        def get_connection_provider
          @connection ||= ::Net::HTTP.new(@host.host, @host.port)
        end

        protected

        def headers=(h)
          @headers = h
        end

        def request_to_s(method, path, *args)
          result = ["#{method.to_s.upcase} #{path}"]

          arguments = args.dup
          headers = arguments.extract_options!

          if [:post, :put].include?(method)
            body = arguments.shift
          end

          result << headers.collect { |key, value| "#{key}: #{value}" }.join("\n")

          (result + [body ? (body.inspect + "\n") : nil]).compact.join("\n") << "\n"
        end
      end
    end
  end
end
