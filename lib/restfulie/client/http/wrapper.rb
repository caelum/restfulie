#
#  Copyright (c) 2009 Caelum - www.caelum.com.br/opensource
#  All rights reserved.
# 
#  Licensed under the Apache License, Version 2.0 (the "License"); 
#  you may not use this file except in compliance with the License. 
#  You may obtain a copy of the License at 
#  
#   http://www.apache.org/licenses/LICENSE-2.0 
#  
#  Unless required by applicable law or agreed to in writing, software 
#  distributed under the License is distributed on an "AS IS" BASIS, 
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
#  See the License for the specific language governing permissions and 
#  limitations under the License. 
#
module Restfulie::Client::HTTP

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

    module ResponseHandler

      @@response_hanlders = {}
      def self.handlers(code)
        @@response_hanlders[code] 
      end

      def self.register(code,response_class)
        @@response_hanlders[code] = response_class 
      end

      def self.handle(method, path, http_response)
        response_class = @@response_hanlders[http_response.code.to_i] || Response
        headers = {}
        http_response.header.each { |k, v| headers[k] = v }
        response = response_class.new( method, path, http_response.code.to_i, http_response.body, headers)
      end

    end

    module RequestAdapter

      attr_reader   :host
      attr_accessor :cookies
      attr_writer   :default_headers

      def host=(host)
        if host.is_a?(URI)
          @host = host
        else
          @host = ::URI.parse(host)
        end
      end

      def default_headers
        @default_headers ||= {}
      end

      def get(path, *args)
        request(:get, path, *args)
      end

      def head(path, *args)
        request(:head, path, *args)
      end

      def post(path, payload, *args)
        request(:post, path, payload, *args)
      end

      def put(path, payload, *args)
        request(:put, path, payload, *args)
      end

      def delete(path, *args)
        request(:delete, path, *args)
      end

      def get!(path, *args)
        request!(:get, path, *args)
      end

      def head!(path, *args)
        request!(:head, path, *args)
      end

      def post!(path, payload, *args)
        request!(:post, path, payload, *args)
      end

      def put!(path, payload, *args)
        request!(:put, path, payload, *args)
      end

      def delete!(path, *args)
        request!(:delete, path, *args)
      end

      def request(method, path, *args)
        request!(method, path, *args) 
      rescue Error::RESTError => se
        se.response
      end

      def request!(method, path, *args)
        headers = default_headers.merge(args.extract_options!)
        unless @host.user.blank? && @host.password.blank?
          headers["Authorization"] = "Basic " + ["#{@host.user}:#{@host.password}"].pack("m").delete("\r\n")
        end
        headers['cookie'] = @cookies if @cookies
        args << headers

        ::Restfulie::Logger.logger.info(request_to_s(method, path, *args)) unless ::Restfulie::Logger.logger
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

        if body.is_a?(Hash)
          body = (body.map { |k,v| "#{k}=#{v}"}.join("&"))
        end

        headers["Content-Length"] = body.length unless body.nil?
        result << headers.collect { |key, value| "#{key}: #{value}" }.join("\n")

        (result + [body ? (body + "\n") : nil]).compact.join("\n") << "\n"
      end

    end

    module RequestBuilder
      include RequestAdapter

      def at(url)
        self.host = url
        self
      end
      
      def as(content_type)
        default_headers['Content-Type'] = content_type
        accepts(content_type)
      end
      
      def accepts(content_type)
        default_headers['Accept'] = content_type
        self
      end
      
      def with(headers)
        default_headers.merge!(headers)
        self
      end

      def path
        host.path
      end

      def get
        request(:get, path, {})
      end

      def head
        request(:head, path, {})
      end

      def post(payload)
        request(:post, path, payload, {})
      end

      def put(payload)
        request(:put, path, payload, {})
      end

      def delete
        request(:delete, path, {})
      end

      def get!
        request!(:get, path, {})
      end

      def head!
        request!(:head, path, {})
      end

      def post!(payload)
        request!(:post, path, payload, {})
      end

      def put!(payload)
        request!(:put, path, payload, {})
      end

      def delete!
        request!(:delete, path, {})
      end

    end

    class RequestExecutor
      include RequestAdapter
      def initialize(host, default_headers = {})
        self.host=host
        self.default_headers=default_headers
      end
    end

    class RequestBuilderExecutor
      include RequestBuilder
      def initialize(host, default_headers = {})
        self.host=host
        self.default_headers=default_headers
      end
      def at(path)
        @path = path
        self
      end
      def path
        @path
      end
    end

end

