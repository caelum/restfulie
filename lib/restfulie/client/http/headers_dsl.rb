require 'uri'

module Restfulie
  module Client
    module HTTP #:nodoc:
      # ==== HeadersDsl
      # Uses RequestAdapater to create a HTTP Request DSL 
      #
      # ==== Example:
      #
      #   @builder = ::Restfulie::Client::HTTP::RequestBuilderExecutor.new("http://restfulie.com") #this class includes HeadersDsl module.
      #   @builder.at('/posts').as('application/xml').accepts('application/atom+xml').with('Accept-Language' => 'en').get.code #=> 200
      #
      class HeadersDsl < MasterDelegator
        
        def initialize(requester)
          @requester = requester
        end

        #Set host
        def at(url)
          host = url
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

        # Merge internal header
        #
        # * <tt>headers (e.g. {'Cache-control' => 'no-cache'})</tt>
        #
        def with(headers)
          headers.merge!(headers)
          self
        end

        # Path (e.g. http://restfulie.com/posts => /posts)
        def path
          puts "GOING TO START ATTTTTTTTT #{url}"
          puts
          puts
          puts
          puts
          puts
          puts
          host.path
        end
        
        protected

        def headers=(h)
          @headers = h
        end
      end
    end
  end
end
