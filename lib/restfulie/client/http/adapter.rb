module Restfulie::Client::HTTP #:nodoc:

    #=Response
    # Default response class
    class Response

      attr_reader :method
      attr_reader :path
      attr_reader :code
      attr_reader :body
      attr_reader :headers

      def initialize(method, path, code, body, headers)
        @method = method
        @path = path
        @code = code
        @body = body 
        @headers = headers
      end
      
    end

    #=ResponseHandler
    # You can change instance registering a class according to the code.
    #
    #==Example
    #
    #   class RequestExecutor
    #     include RequestAdapter
    #     def initialize(host)
    #       self.host=host
    #     end
    #   end
    #
    #   class FakeResponse < Restfulie::Client::HTTP::Response
    #   end
    #
    #   Restfulie::Client::HTTP::ResponseHandler.register(201,FakeResponse)  
    #   @re = Restfulie::Client::HTTP::RequestExecutor.new('http://restfulie.com')
    #   puts @re.as('application/atom+xml').get!('/posts').class.to_i #=> FakeResponse
    #
    module ResponseHandler

      @@response_handlers = {}
      ## 
      # :singleton-method:
      # Response handlers attribute reader
      # * code: HTTP status code
      def self.handlers(code)
        @@response_handlers[code] 
      end

      ## 
      # :singleton-method:
      # Use to register response handlers
      #
      # * <tt>code: HTTP status code</tt>
      # * <tt>response_class: Response class</tt>
      #
      #==Example:
      #   class FakeResponse < ::Restfulie::Client::HTTP::Response
      #   end
      #
      #   Restfulie::Client::HTTP::ResponseHandler.register(200,FakeResponse)  
      #
      def self.register(code,response_class)
        @@response_handlers[code] = response_class 
      end

      ## 
      # :singleton-method:
      # Request Adapter uses this method to choose response instance
      #
      # *<tt>method: :get,:post,:delete,:head,:put</tt>
      # *<tt>path: '/posts'</tt>
      # *<tt>http_response</tt>
      #
      def self.handle(method, path, http_response)
        response_class = @@response_handlers[http_response.code.to_i] || Response
        headers = {}
        http_response.header.each { |k, v| headers[k] = v }
        response_class.new( method, path, http_response.code.to_i, http_response.body, headers)
      end

    end

    #
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

      #GET HTTP verb without {Error}
      # * <tt>path: '/posts'</tt>
      # * <tt>headers: {'Accpet' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
      def get(path, *args)
        request(:get, path, *args)
      end

      #HEAD HTTP verb without {Error}
      # * <tt>path: '/posts'</tt>
      # * <tt>headers: {'Accpet' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
      def head(path, *args)
        request(:head, path, *args)
      end

      #POST HTTP verb without {Error}
      # * <tt>path: '/posts'</tt>
      # * <tt>payload: 'some text'</tt>
      # * <tt>headers: {'Accpet' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
      def post(path, payload, *args)
        request(:post, path, payload, *args)
      end

      #PUT HTTP verb without {Error}
      # * <tt>path: '/posts'</tt>
      # * <tt>payload: 'some text'</tt>
      # * <tt>headers: {'Accpet' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
      def put(path, payload, *args)
        request(:put, path, payload, *args)
      end

      #DELETE HTTP verb without {Error}
      # * <tt>path: '/posts'</tt>
      # * <tt>headers: {'Accpet' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
      def delete(path, *args)
        request(:delete, path, *args)
      end

      #GET HTTP verb {Error}
      # * <tt>path: '/posts'</tt>
      # * <tt>headers: {'Accpet' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
      def get!(path, *args)
        request!(:get, path, *args)
      end

      #HEAD HTTP verb {Error}
      # * <tt>path: '/posts'</tt>
      # * <tt>headers: {'Accpet' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
      def head!(path, *args)
        request!(:head, path, *args)
      end

      #POST HTTP verb {Error}
      # * <tt>path: '/posts'</tt>
      # * <tt>payload: 'some text'</tt>
      # * <tt>headers: {'Accpet' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
      def post!(path, payload, *args)
        request!(:post, path, payload, *args)
      end

      #PUT HTTP verb {Error}
      # * <tt>path: '/posts'</tt>
      # * <tt>payload: 'some text'</tt>
      # * <tt>headers: {'Accpet' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
      def put!(path, payload, *args)
        request!(:put, path, payload, *args)
      end

      #DELETE HTTP verb {Error}
      # * <tt>path: '/posts'</tt>
      # * <tt>headers: {'Accpet' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
      def delete!(path, *args)
        request!(:delete, path, *args)
      end

      #Executes a request against your server and return a response instance without {Error}
      # * <tt>method: :get,:post,:delete,:head,:put</tt>
      # * <tt>path: '/posts'</tt>
      # * <tt>args: payload: 'some text' and/or headers: {'Accpet' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
      def request(method, path, *args)
        request!(method, path, *args) 
      rescue Error::RESTError => se
        se.response
      end

      #Executes a request against your server and return a response instance.
      # * <tt>method: :get,:post,:delete,:head,:put</tt>
      # * <tt>path: '/posts'</tt>
      # * <tt>args: payload: 'some text' and/or headers: {'Accpet' => '*/*', 'Content-Type' => 'application/atom+xml'}</tt>
      def request!(method, path, *args)
        headers = default_headers.merge(args.extract_options!)
        unless @host.user.blank? && @host.password.blank?
          headers["Authorization"] = "Basic " + ["#{@host.user}:#{@host.password}"].pack("m").delete("\r\n")
        end
        headers['cookie'] = @cookies if @cookies
        args << headers

        ::Restfulie::Common::Logger.logger.info(request_to_s(method, path, *args)) if ::Restfulie::Common::Logger.logger
        begin
          response = ResponseHandler.handle(method, path, get_connection_provider.send(method, path, *args))
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

    #=RequestBuilder
    # Uses RequestAdapater to create a HTTP Request DSL 
    #
    #==Example:
    #
    #   @builder = ::Restfulie::Client::HTTP::RequestBuilderExecutor.new("http://restfulie.com") #this class includes RequestBuilder module.
    #   @builder.at('/posts').as('application/xml').accepts('application/atom+xml').with('Accept-Language' => 'en').get.code #=> 200
    #
    module RequestBuilder
      include RequestAdapter

      #Set host
      def at(url)
        self.host = url
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
     
      #
      #Merge internal header
      #
      # * <tt>headers (e.g. {'Cache-control' => 'no-cache'})</tt>
      #
      def with(headers)
        self.headers.merge!(headers)
        self
      end

      def headers
        @headers || @headers = {}
      end
      
      #Path (e.g. http://restfulie.com/posts => /posts)
      def path
        host.path
      end

      def get
        request(:get, path, headers)
      end

      def head
        request(:head, path, headers)
      end

      def post(payload)
        request(:post, path, payload, headers)
      end

      def put(payload)
        request(:put, path, payload, headers)
      end

      def delete
        request(:delete, path, headers)
      end

      def get!
        request!(:get, path, headers)
      end

      def head!
        request!(:head, path, headers)
      end

      def post!(payload)
        request!(:post, path, payload, headers)
      end

      def put!(payload)
        request!(:put, path, payload, headers)
      end

      def delete!
        request!(:delete, path, headers)
      end

      protected

      def headers=(h)
        @headers = h
      end

    end


    #=RequestFollow follow new location of a document usually with response codes 201,301,302,303 and 307. You can also configure other codes.
    # 
    #==Example:
    # @executor = ::Restfulie::Client::HTTP::RequestFollowExecutor.new("http://restfulie.com") #this class includes RequestFollow module.
    # @executor.at('/custom/songs').accepts('application/atom+xml').follow(201).post!("custom").code
    module RequestFollow
      include RequestBuilder

      def follow(code)
        follow_codes << code unless follow_codes.include?(code)
        self
      end

      def request!(method, path, *args)#:nodoc:
        response = super
        if follow_codes.include?(response.code)
          location = response.headers['location'] || response.headers['Location']
          raise Error::CreatedStatusWithoutLocationHeader.new(self, response) unless location
          self.host = location
          response = super(:get, self.path, headers)
        end
        response
      end

      protected

      def follow_codes
        @follow || @follow = [201,301,302,303,307]        
      end

    end

    #=RequestHistory
    # Uses RequestBuilder and remind previous requests
    #
    #==Example:
    #
    #   @executor = ::Restfulie::Client::HTTP::RequestHistoryExecutor.new("http://restfulie.com") #this class includes RequestHistory module.
    #   @executor.at('/posts').as('application/xml').accepts('application/atom+xml').with('Accept-Language' => 'en').get.code #=> 200 #first request
    #   @executor.at('/blogs').as('application/xml').accepts('application/atom+xml').with('Accept-Language' => 'en').get.code #=> 200 #second request
    #   @executor.request_history!(0) #doing first request
    #
    module RequestHistory
      include RequestFollow

      attr_accessor_with_default :max_to_remind, 10

      def snapshots
        @snapshots || @snapshots = []
      end

      def request!(method=nil, path=nil, *args)#:nodoc:
        if method == nil || path == nil 
          raise 'History not selected' unless @snapshot
          super( @snapshot[:method], @snapshot[:path], *@snapshot[:args] )
        else
          @snapshot = make_snapshot(method, path, *args)
          unless snapshots.include?(@snapshot)
            snapshots.shift if snapshots.size >= max_to_remind
            snapshots << @snapshot
          end
          super
        end
      end

      def request(method=nil, path=nil, *args)#:nodoc:
        request!(method, path, *args) 
      rescue Error::RESTError => se
        se.response
      end

      def history(number)
        @snapshot = snapshots[number]
        raise "Undefined snapshot for #{number}" unless @snapshot
        self.host    = @snapshot[:host]
        self.cookies = @snapshot[:cookies]
        self.headers = @snapshot[:headers]
        self.default_headers = @snapshot[:default_headers]
        at(@snapshot[:path])
      end

      private

      def make_snapshot(method, path, *args)
        arguments = args.dup
        cutom_headers = arguments.extract_options!
        { :host            => self.host.dup,
          :default_headers => self.default_headers.dup,
          :headers         => self.headers.dup,
          :cookies         => self.cookies,
          :method          => method, 
          :path            => path,
          :args            => arguments << self.headers.merge(cutom_headers)   }
      end

    end

    #=This class includes RequestAdapter module.
    class RequestExecutor
      include RequestAdapter

      # * <tt> host (e.g. 'http://restfulie.com') </tt>
      # * <tt> default_headers  (e.g. {'Cache-control' => 'no-cache'} ) </tt>
      def initialize(host, default_headers = {})
        self.host=host
        self.default_headers=default_headers
      end

    end

    #=This class includes RequestBuilder module.
    class RequestBuilderExecutor < RequestExecutor
      include RequestBuilder

      def host=(host)
        super
        at(self.host.path)
      end

      def at(path)
        @path = path
        self
      end

      def path
        @path
      end

    end

    #=This class inherits RequestBuilderExecutor and include RequestFollow module.
    class RequestFollowExecutor < RequestBuilderExecutor
      include RequestFollow
    end

    #=This class inherits RequestFollowExecutor and include RequestHistory module.
    class RequestHistoryExecutor < RequestFollowExecutor
      include RequestHistory
    end

end
