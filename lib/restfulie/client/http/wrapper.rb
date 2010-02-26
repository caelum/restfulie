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

      attr_reader :code
      attr_reader :contents
      attr_reader :headers

      def initialize(method, path, response)
        @code = response.code.to_i
        @contents = response.body || ""
        @headers = {}
        load_headers(response)
      end

      def load_headers(response)
        response.header.each { |k, v| @headers[k] = v }
      end

    end

    module ResponseHandler

      @@responses = { }

      def self.register(code,response_class)
        @@responses[code] = response_class 
      end

      def self.handle(method, path, http_response)
        response_class = @@responses[http_response.code.to_i] || Response
        response = response_class.new( method, path, http_response )
      end

      def self.handle!(method, path, http_response)

        response = handle(method, path, http_response)

        case response.code
        when 100..299
          response 
        when 300..399
          raise Error::Redirection.new(method, path, response)
        when 400
          raise Error::BadRequest.new(method, path, response)
        when 401
          raise Error::Unauthorized.new(method, path, response)
        when 403
          raise Error::Forbidden.new(method, path, response)
        when 404
          raise Error::NotFound.new(method, path, response)
        when 405
          raise Error::MethodNotAllowed.new(method, path, response)
        when 407
          raise Error::ProxyAuthenticationRequired.new(method, path, response)
        when 409
          raise Error::Conflict.new(method, path, response)
        when 410
          raise Error::Gone.new(method, path, response)
        when 412
          raise Error::PreconditionFailed.new(method, path, response)
        when 402, 406, 408, 411, 413..499
          raise Error::ClientError.new(method, path, response)
        when 501
          raise Error::NotImplemented.new(method, path, response)
        when 500, 502..599
          raise Error::ServerError.new(method, path, response)
        else
          raise Error::UnknownError.new(method, path, response)
        end
      end

    end

    module Base

      mattr_accessor :logger

      def init(root, default_headers = {}, logger = nil)
        @url = root
        @root = ::URI.parse(root)
        @default_headers = default_headers
        @connection = get_connect
        @@logger = logger unless logger.nil?
        @cookies=nil
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

      def request(method, path, *args)

        headers = @default_headers.merge(args.extract_options!)
        unless @root.user.blank? && @root.password.blank?
          headers["Authorization"] = "Basic " + ["#{@root.user}:#{@root.password}"].pack("m").delete("\r\n")
        end
        headers['cookie'] = @cookies if @cookies
        args << headers

        logger.info(request_to_s(method, path, *args)) unless logger.nil?
        begin
          ResponseHandler.handle!(method, path, @connection.send(method, path, *args))
        rescue Errno::ECONNREFUSED
          raise Error::ServerNotAvailableError.new("The server at #{@url} is not available.")
       end
      end

      def cookies=(value)
        @cookies=value
      end

      def cookies
        @cookies
      end

      private

      def get_connect
        ::Net::HTTP.new(@root.host, @root.port)
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

    module Builder
      include Base

      def init(root, default_headers = {}, logger = nil)
        super
        @headers = {
          'Accept'       => 'application/atom+xml',
          'Content-Type' => 'application/atom+xml'
        }
      end

      def at(uri)
        @uri = uri
        self
      end
      
      def as(content_type)
        @headers['Content-Type'] = content_type
        accepts(content_type)
      end
      
      def accepts(content_type)
        @headers['Accept'] = content_type
        self
      end
      
      def with(headers)
        @headers.merge!(headers)
        self
      end

      def get
        request(:get, @uri, @headers)
      end

      def head
        request(:head, @uri, @headers)
      end

      def post(payload)
        request(:post, @uri, payload, @headers)
      end

      def put(payload)
        request(:put, @uri, payload, @headers)
      end

      def delete
        request(:delete, @uri, @headers)
      end

    end

    class RequestExecutor
      include Base
      def initialize(root, default_headers = {}, logger = nil)
        init(root, default_headers, logger)
      end
    end

    class RequestExecutorBuilder
      include Builder
      def initialize(root, default_headers = {}, logger = nil)
        init(root, default_headers, logger)
      end
    end

end

