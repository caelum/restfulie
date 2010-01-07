module Restfulie
  module Client
    
    module WebResponse
      
      attr_accessor :web_response
      
    end
    
    class Response
      
      def initialize(type, response)
        @type = type
        @response = response
      end
      
      def parse_post
        code = @response.code
        if code=="301" && @type.follows.moved_permanently? == :all
          result = @type.remote_post_to(@response["Location"], @response.body)
          enhance(result, @response)
        elsif code=="201"
          from_web(@response["Location"], "Accept" => "application/xml")
        else
          enhance(@response, @response)
        end
      end
      
      private
      # gets a result object and enhances it with web response methods
      # by extending WebResponse and defining the attribute web_response
      def enhance(result, response)
        result.extend Restfulie::Client::WebResponse
        result.web_response = response
        result
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
        Restfulie::Client::Response.new(response).parse_post
      end

      def from_web(uri, options = {})
        uri = URI.parse(uri)
        req = Net::HTTP::Get.new(uri.path)
        options.each do |key,value| req[key] = value end 
        add_basic_request_headers(req)
        
        res = Net::HTTP.new(uri.host, uri.port).request(req)
        parse_get_response(res)
      end
      
      private
      
      def add_basic_request_headers(req)
        req.add_field("Accept", @accepts) unless @accepts.nil?
      end
      
      # parses a get response.
      # if the result code is 301, redirect
      # otherwise, parses an ok response
      def parse_get_response(res)
        
        code = res.code
        return from_web(res["Location"]) if code=="301"
        parse_get_ok_response(res, code)
        
      end
      
      # parses a successful get response.
      # parses the entity and add extra (response related) fields.
      def parse_get_ok_response(res, code)
        result = parse_get_entity(res, code)
        add_extra_fields(result, res)
        result
      end
      
      # add etag, last_modified and web_response fields to the resulting object
      def add_extra_fields(result,res)
        result.etag = res['Etag'] unless res['Etag'].nil?
        result.last_modified = res['Last-Modified'] unless res['Last-Modified'].nil?
        result.web_response = res
      end
      
      # returns an entity for a specific response
      def parse_get_entity(res, code)
        if code=="200"
          content_type = res.content_type
          type = Restfulie::MediaType.type_for(content_type)
          if content_type[-3,3]=="xml"
            result = type.from_xml res.body
          elsif content_type[-4,4]=="json"
            result = type.from_json res.body
          else
            raise Restfulie::UnsupportedContentType.new("unsupported content type '#{content_type}'")
          end
          result
        else
          res
        end
      end
      
    end
  end
end