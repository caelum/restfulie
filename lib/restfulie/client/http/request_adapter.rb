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
      module RequestAdapter
        attr_reader   :host
        attr_accessor :cookies
        attr_writer   :default_headers

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

        # GET HTTP verb without {Error}
        # * <tt>path: '/posts'</tt>
        # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
        def get(path, *args)
          request(:get, path, *args)
        end

        # HEAD HTTP verb without {Error}
        # * <tt>path: '/posts'</tt>
        # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
        def head(path, *args)
          request(:head, path, *args)
        end

        # POST HTTP verb without {Error}
        # * <tt>path: '/posts'</tt>
        # * <tt>payload: 'some text'</tt>
        # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
        def post(path, payload, *args)
          request(:post, path, payload, *args)
        end

        # PATCH HTTP verb without {Error}
        # * <tt>path: '/posts'</tt>
        # * <tt>payload: 'some text'</tt>
        # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
        def patch(path, payload, *args)
          request(:patch, path, payload, *args)
        end

        # PUT HTTP verb without {Error}
        # * <tt>path: '/posts'</tt>
        # * <tt>payload: 'some text'</tt>
        # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
        def put(path, payload, *args)
          request(:put, path, payload, *args)
        end

        # DELETE HTTP verb without {Error}
        # * <tt>path: '/posts'</tt>
        # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
        def delete(path, *args)
          request(:delete, path, *args)
        end

        # GET HTTP verb {Error}
        # * <tt>path: '/posts'</tt>
        # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
        def get!(path, *args)
          request!(:get, path, *args)
        end

        # HEAD HTTP verb {Error}
        # * <tt>path: '/posts'</tt>
        # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
        def head!(path, *args)
          request!(:head, path, *args)
        end

        # POST HTTP verb {Error}
        # * <tt>path: '/posts'</tt>
        # * <tt>payload: 'some text'</tt>
        # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
        def post!(path, payload, *args)
          request!(:post, path, payload, *args)
        end

        # PATCH HTTP verb {Error}
        # * <tt>path: '/posts'</tt>
        # * <tt>payload: 'some text'</tt>
        # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
        def patch!(path, payload, *args)
          request!(:patch, path, payload, *args)
        end

        # PUT HTTP verb {Error}
        # * <tt>path: '/posts'</tt>
        # * <tt>payload: 'some text'</tt>
        # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
        def put!(path, payload, *args)
          request!(:put, path, payload, *args)
        end

        # DELETE HTTP verb {Error}
        # * <tt>path: '/posts'</tt>
        # * <tt>headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
        def delete!(path, *args)
          request!(:delete, path, *args)
        end

        # Executes a request against your server and return a response instance without {Error}
        # * <tt>method: :get,:post,:delete,:head,:put</tt>
        # * <tt>path: '/posts'</tt>
        # * <tt>args: payload: 'some text' and/or headers: {'Accept' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
        def request(method, path, *args)
          request!(method, path, *args) 
        rescue Error::RESTError => se
          se.response
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
            response = Restfulie::Client.cache_provider.get([@host, path], http_request)
            response ||= ResponseHandler.handle(method, path, http_request.send(method, path, *args))
            Restfulie::Client.cache_provider.put([@host, path], http_request, response)
          rescue Exception => e
            raise Error::ServerNotAvailableError.new(self, Response.new(method, path, 503, nil, {}), e )
          end 

          case response.code
          when 100..299
            response 
          when 300..399
            raise Error::Redirection.new(self, response)
          when 400
            raise Error::BadRequest.new(self, response)
          when 401
            raise Error::Unauthorized.new(self, response)
          when 403
            raise Error::Forbidden.new(self, response)
          when 404
            raise Error::NotFound.new(self, response)
          when 405
            raise Error::MethodNotAllowed.new(self, response)
          when 407
            raise Error::ProxyAuthenticationRequired.new(self, response)
          when 409
            raise Error::Conflict.new(self, response)
          when 410
            raise Error::Gone.new(self, response)
          when 412
            raise Error::PreconditionFailed.new(self, response)
          when 402, 406, 408, 411, 413..499
            raise Error::ClientError.new(self, response)
          when 501
            raise Error::NotImplemented.new(self, response)
          when 500, 502..599
            raise Error::ServerError.new(self, response)
          else
            raise Error::UnknownError.new(self, response)
          end
        end

        private

        def get_connection_provider
          @connection ||= ::Net::HTTP.new(@host.host, @host.port)
        end

        protected

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
