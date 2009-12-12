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

      private
      def remote_post_to(uri, content)
        
        url = URI.parse(uri)
        req = Net::HTTP::Post.new(url.path)
        req.body = content
        req.add_field("Accept", @content_type)
        req.add_field("Content-type", @content_type)

        response = Net::HTTP.new(url.host, url.port).request(req)
        code = response.code
        
        if code=="301" && @type.follows.moved_permanently? == :all
          remote_post_to(response["Location"], content)
        elsif code=="201"
          type.from_web(response["Location"], "Accept" => "application/xml")
        else
          response
        end

      end

      
    end
  end
end