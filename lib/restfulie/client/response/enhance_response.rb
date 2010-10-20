module Restfulie
  module Client
    module Response
      class EnhanceResponse
        def initialize(requester)
          @requester = requester
        end

        def parse(host, path, http_request, request, response, method)
          resp = @requester.parse(host, path, http_request, request, response, method)
          unless resp.kind_of? ::Restfulie::Client::HTTP::ResponseHolder
            resp.extend(::Restfulie::Client::HTTP::ResponseHolder)
            resp.response = response
          end
          resp
        end
      end
    end
  end
end