module Restfulie
  module Client
    module Response
      
      class EnhanceResponse
        def initialize(requester)
          @requester = requester
        end

        def parse(host, path, http_request, request, response)
          resp = @requester.parse(host, path, http_request, request, response)
          unless resp.kind_of? ResponseHolder
            resp.extend(ResponseHolder)
            resp.response = response
          end
          resp
        end
      end
    end
  end
end