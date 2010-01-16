require 'restfulie/client/extensions/http'

module Restfulie
  module Client
    
    # extension to all answers that allows you to access the web response
    module WebResponse
      attr_accessor :web_response
    end
    
    # TODO there should be a response for each method type
    class Response
      
      def initialize(type, response)
        @type = type
        @response = response
      end

      # TODO remote_post can probably be moved, does not need to be on the object's class itself
      # the expected_content_type is used in case a redirection takes place
      def parse_post(expected_content_type)
        code = @response.code
        if code=="301" && @type.follows.moved_permanently? == :all
          result = @type.remote_post_to(@response["Location"], @response.body)
          enhance(result)
        elsif code=="201"
          Restfulie.at(@response["Location"]).accepts(expected_content_type).get
        else
          enhance parse_get_entity(code)
        end
      end
      
      # gets a result object and enhances it with web response methods
      # by extending WebResponse and defining the attribute web_response
      def enhance(result)
        @response.extend Restfulie::Client::HTTPResponse
        @response.previous = result.web_response if result.respond_to? :web_response
        result.extend Restfulie::Client::WebResponse
        result.web_response = @response
        result
      end

      # parses a get response.
      # if the result code is 301, redirect
      # otherwise, parses an ok response
      def parse_get_response
        
        code = @response.code
        return enhance(from_web(@response["Location"])) if code=="301"
        enhance parse_get_entity(code)
      end
      
      # returns an entity for a specific response
      def parse_get_entity(code)
        return @response unless code == "200"
        
        content_type = @response.content_type
        type = Restfulie::MediaType.type_for(content_type)
        if content_type[-3,3]=="xml"
          result = type.from_xml @response.body
        elsif content_type[-4,4]=="json"
          result = type.from_json @response.body
        else
          result = generic_parse_get_entity content_type, type
        end
        result.instance_variable_set :@_came_from, content_type
        result
        
      end

      def generic_parse_get_entity(content_type, type)
        method = "from_#{content_type}".to_sym
        raise Restfulie::UnsupportedContentType.new("unsupported content type '#{content_type}' because '#{type}.#{method.to_s}' was not found") unless type.respond_to? method
        type.send(method, @response.body)
      end

      # detects which type of method invocation it was and act accordingly
      # TODO this should be called by RequestExcution, not instance
      def parse(method, invoking_object, content_type)

        return enhance(invoking_object) if @response.code == "304"

        # return block.call(@response) if block

        return parse_get_response if method == Net::HTTP::Get
        return parse_post(content_type) if method == Net::HTTP::Post
        parse_get_response
        
      end
      
    end

    class RequestExecution
      
      def initialize(type)
        initialize(type, nil)
      end

      def initialize(type, invoking_object)
        @type = type
        @content_type = "application/xml"
        @accepts = "application/xml"
        @invoking_object = invoking_object
      end

      def at(uri)
        @uri = uri
        self
      end
      
      # sets the Content-type AND Accept headers for this request
      def as(content_type)
        @content_type = content_type
        @accepts = content_type
        self
      end
      
      # sets the Accept header for this request
      def accepts(content_type)
        @accepts = content_type
        self
      end
      
      def with(headers)
        @headers = headers
        self
      end

      # asks to create this content on the server (post it)
      def create(content)
        post(content)
      end
      
      def do(what, name, content = nil)
        url = URI.parse(@uri)
        req = what.new(url.path)
        add_basic_request_headers(req, name)
        
        if content
          req.body = content
          req.add_field("Content-type", "application/xml") if req.get_fields("Content-type").nil?
        end
        
        response = Net::HTTP.new(url.host, url.port).request(req)
        Restfulie::Client::Response.new(@type, response).parse(what, @invoking_object, "application/xml")
        
      end

      # post this content to the server
      def post(content)
        remote_post_to(@uri, content)
      end
      
      # retrieves information from the server using a GET request
      def get(options = {})
        from_web(@uri, options)
      end
      
      def add_headers_to(hash)
        hash[:headers] = {} unless hash[:headers]
        hash[:headers]["Content-type"] = @content_type
        hash[:headers]["Accept"] = @accepts
        hash
      end
      
      def change_to_state(name, args)
        if !args.empty? && args[args.size-1].kind_of?(Hash)
          add_headers_to(args[args.size-1])
        else
          args << add_headers_to({})
        end
        @invoking_object.invoke_remote_transition name, args
      end
      
      # invokes an existing relation or delegates to the existing definition of method_missing
      def method_missing(name, *args)
        if @invoking_object && @invoking_object.existing_relations[name.to_s]
          change_to_state(name.to_s, args)
        else
          super(name, args)
        end
      end

      def add_basic_request_headers(req, name = nil)
        
        req.add_field("Accept", @accepts) unless @accepts.nil?
        
        @headers.each do |key, value|
          req.add_field(key, value)
        end if @headers
        
        req.add_field("Accept", @invoking_object._came_from) if req.get_fields("Accept")==["*/*"]
        
        if @type && name && @type.is_self_retrieval?(name) && @invoking_object.respond_to?(:web_response)
          req.add_field("If-None-Match", @invoking_object.web_response.etag) if !@invoking_object.web_response.etag.nil?
          req.add_field("If-Modified-Since", @invoking_object.web_response.last_modified) if !@invoking_object.web_response.last_modified.nil?
        end
        
      end

      private
      def remote_post_to(uri, content)
        
        url = URI.parse(uri)
        req = Net::HTTP::Post.new(url.path)
        req.body = content
        add_basic_request_headers(req)
        req.add_field("Content-type", @content_type)

        response = Net::HTTP.new(url.host, url.port).request(req)
        Restfulie::Client::Response.new(@type, response).parse_post(@content_type)
      end

      def from_web(uri, options = {})
        uri = URI.parse(uri)
        req = Net::HTTP::Get.new(uri.path)
        options.each { |key,value| req[key] = value }
        add_basic_request_headers(req)
        res = Net::HTTP.new(uri.host, uri.port).request(req)
        Restfulie::Client::Response.new(@type, res).parse_get_response
      end
      
      
    end
  end
end