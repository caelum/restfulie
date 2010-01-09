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
          enhance(@response)
        end
      end
      
      # gets a result object and enhances it with web response methods
      # by extending WebResponse and defining the attribute web_response
      def enhance(result)
        @response.extend Restfulie::Client::HTTPResponse
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
        enhance parse_get_ok_response(code)
        
      end
      
      # parses a successful get response.
      # parses the entity and add extra (response related) fields.
      def parse_get_ok_response(code)
        result = parse_get_entity(code)
        result
      end
      
      # returns an entity for a specific response
      def parse_get_entity(code)
        if code=="200"
          content_type = @response.content_type
          type = Restfulie::MediaType.type_for(content_type)
          if content_type[-3,3]=="xml"
            result = type.from_xml @response.body
          elsif content_type[-4,4]=="json"
            result = type.from_json @response.body
          else
            method = "from_#{content_type}".to_sym
            raise Restfulie::UnsupportedContentType.new("unsupported content type '#{content_type}' because '#{type}.#{method.to_s}' was not found") unless type.respond_to? method
            result = type.send(method, @response.body)
          end
          result
        else
          @response
        end
      end

      # detects which type of method invocation it was and act accordingly
      # TODO this should be called by RequestExcution, not instance
      def parse(method, invoking_object, content_type)

        return invoking_object if @response.code == "304"

        # return block.call(@response) if block

        return parse_get_response if method == Net::HTTP::Get
        parse_post(content_type) if method == Net::HTTP::Post
        parse_get_response
        
      end
      
    end

    class RequestExecution
      
      def initialize(type)
        @type = type
        @content_type = "application/xml"
        @accepts = "application/xml"
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

      # asks to create this content on the server (post it)
      def create(content)
        post(content)
      end

      # post this content to the server
      def post(content)
        remote_post_to(@uri, content)
      end
      
      # retrieves information from the server using a GET request
      def get(options = {})
        from_web(@uri, options)
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
        options.each do |key,value| req[key] = value end 
        add_basic_request_headers(req)
        
        res = Net::HTTP.new(uri.host, uri.port).request(req)
        Restfulie::Client::Response.new(@type, res).parse_get_response
      end
      
      private
      
      def add_basic_request_headers(req)
        req.add_field("Accept", @accepts) unless @accepts.nil?
      end
      
    end
  end
end