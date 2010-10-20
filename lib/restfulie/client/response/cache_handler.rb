module Restfulie
  module Client
    module Response
      class CacheHandler

        def initialize(requester)
          @requester = requester
        end

        def parse(host, path, http_request, request, response)
          Restfulie::Client.cache_provider.put([host, path], http_request, response)
          @requester.parse(host, path, http_request, request, response)
        end
      end
    end
  end
end