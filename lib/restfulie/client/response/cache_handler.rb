module Restfulie
  module Client
    module Response
      class CacheHandler

        def initialize(requester)
          @requester = requester
        end

        def parse(host, path, http_request, request, response, method)
          unless response.kind_of? Exception
            Restfulie::Client.cache_provider.put([host, path], http_request, response)
          end
          @requester.parse(host, path, http_request, request, response, method)
        end
      end
    end
  end
end