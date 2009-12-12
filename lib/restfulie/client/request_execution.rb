module Restfulie
  module Client

    class RequestExecution
      
      def initialize(type)
        @type = type
        @content_type = "application/xml"
      end

      def at(uri)
        @uri = uri
        self
      end
      
      def as(content_type)
        @content_type = content_type
        self
      end

      def create(content)
        post(content)
      end

      def post(content)
        remote_post_to(@uri, content)
      end
      
      def get(options = {})
        from_web(@uri, options)
      end

      private
      def remote_post_to(uri, content)
        
        url = URI.parse(uri)
        req = Net::HTTP::Post.new(url.path)
        req.body = content
        req.add_field("Accept", @content_type)
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
        res = Net::HTTP.start(uri.host, uri.port).request(req)

        code = res.code
        return from_web(res["Location"]) if code=="301"
        result = from_web_parse(res, code)
        result.etag = res['Etag'] unless res['Etag'].nil?
        result.last_modified = res['Last-Modified'] unless res['Last-Modified'].nil?
        result.web_response = res
        result

      end
      
      def from_web_parse(res, code)
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