module Restfulie
  module Client

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
        parse_post_response(response, content)
      end
      
      def parse_post_response(response, content)
        code = response.code
        if code=="301" && @type.follows.moved_permanently? == :all
          remote_post_to(response["Location"], content)
        elsif code=="201"
          from_web(response["Location"], "Accept" => "application/xml")
        else
          response
        end
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
      
      def parse_get_response(res)
        
        code = res.code
        return from_web(res["Location"]) if code=="301"
        parse_get_ok_response(res, code)
        
      end
      
      def parse_get_ok_response(res, code)
        result = parse_get_entity(res, code)
        add_extra_fields(result, res)
        result
      end
      
      def add_extra_fields(result,res)
        result.etag = res['Etag'] unless res['Etag'].nil?
        result.last_modified = res['Last-Modified'] unless res['Last-Modified'].nil?
        result.web_response = res
      end
      
      def parse_get_entity(res, code)
        if code=="200"
          content_type = res.content_type
          # TODO really support different content types
          type = Restfulie::MediaType.media_type(content_type)
          if content_type[-3,3]=="xml"
            result = type.from_xml res.body
          elsif content_type[-4,4]=="json"
            result = type.from_json res.body
          else
            raise UnsupportedContentType.new("unsupported content type '#{content_type}'")
          end
          result
        else
          res
        end
      end
      
    end
  end
end