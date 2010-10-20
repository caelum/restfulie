module Restfulie
  module Client
    module Response
      class IgnoreError
  
        def initialize(requester)
          @requester = requester
        end

        def parse(host, path, http_request, request, response)
          begin
            @requester.parse(host, path, http_request, request, response)
          rescue Restfulie::Client::HTTP::Error::RESTError => se
            se
          end
        end
  
      end
    end
  end
end