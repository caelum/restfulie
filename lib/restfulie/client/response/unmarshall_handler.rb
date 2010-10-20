module Restfulie
  module Client
    module Response
      class UnmarshallHandler
  
        def initialize(config, requester)
          @config = config
          @requester = requester
        end
  
        # parses the http response.
        # first checks if its a 201, redirecting to the resource location.
        # otherwise check if its a raw request, returning the content itself.
        # finally, tries to parse the content with a mediatype handler or returns the response itself.
        def parse(host, path, http_request, request, response)
          response = @requester.parse(host, path, http_request, request, response)
          if @config.raw?
            response
          elsif (!response.body.nil?) && !response.body.empty?
            representation = Restfulie::Client::HTTP::RequestMarshaller.content_type_for(response.headers['content-type']) || Restfulie::Common::Representation::Generic.new
            representation.unmarshal(response.body)
          else
            response
          end
        end
      end
    end
  end
end