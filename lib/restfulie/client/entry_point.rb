module Restfulie
  module Client
    module Base
      
      # configures an entry point
      def entry_point_for
        @entry_points ||= EntryPointControl.new(self)
        @entry_points
      end
      
      # executes a POST request to create this kind of resource at the server
      def remote_create(content)
        content = content.to_xml unless content.kind_of? String
        remote_post content
      end
      
      # handles which types of responses should be automatically followed
      def follows
        @follower ||= FollowConfig.new
        @follower
      end
      
      # retrieves a resource form a specific uri
      def from_web(uri, options = {})
        uri = URI.parse(uri)
        req = Net::HTTP::Get.new(uri.path)
        options.each do |key,value| req[key] = value end 
        res = Net::HTTP.start(uri.host, uri.port) {|http|
          http.request(req) # canc hange to straight .request(req)
        }

        code = res.code
        return from_web(res["Location"]) if code=="301"

        if code=="200"
          # TODO really support different content types
          case res.content_type
          when "application/xml"
            result = self.from_xml res.body
          when "application/json"
            result = self.from_json res.body
          else
            raise "unknown content type: #{res.content_type}"
          end
          result.etag = res['Etag'] unless res['Etag'].nil?
          result.last_modified = res['Last-Modified'] unless res['Last-Modified'].nil?
          result
        else
          res
        end
      
      end

      private
      def remote_post(content)
        remote_post_to(entry_point_for.create.uri, content)
      end
      def remote_post_to(uri, content)
        
        url = URI.parse(uri)
        req = Net::HTTP::Post.new(url.path)
        req.body = content
        req.add_field("Accept", "application/xml")

        response = Net::HTTP.new(url.host, url.port).request(req)
        code = response.code
        
        if code=="301" && follows.moved_permanently? == :all
          remote_post_to(response["Location"], content)
        elsif code=="201"
          from_web(response["Location"], "Accept" => "application/xml")
        else
          response
        end

      end
      
    end
    
    class FollowConfig
      def initialize
        @entries = {
          :moved_permanently => [:get, :head]
        }
      end
      def method_missing(name, *args)
        return value_for(name) if name.to_s[-1,1] == "?"
        set_all_for name
      end
      
      private
      def set_all_for(name)
        @entries[name] = :all
      end
      def value_for(name)
        return @entries[name.to_s.chop.to_sym]
      end
    end
    
    class EntryPointControl
      
      def initialize(type)
        @type = type
        @entries = {}
      end
      
      def method_missing(name, *args)
        @entries[name] ||= EntryPoint.new
        @entries[name]
      end

    end
    
    class EntryPoint
      attr_accessor :uri
      def at(uri)
        @uri = uri
      end
    end
    
  end
end
