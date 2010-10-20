module Restfulie
  module Client
    module Response
      class CreatedRedirect

        def initialize(config, requester)
          @config = config
          @requester = requester
        end

        def parse(host, path, http_request, request, response)
          result = @requester.parse(host, path, http_request, request, response)
          response = result.respond_to?(:response) ? result.response : result
          if response.respond_to?(:code) && response.code == 201
            request = Restfulie.at(response.headers['location'])
            request.accepts(@config.acceptable_mediatypes) if @config.acceptable_mediatypes
            request.get!
          else
            response
          end
        end
      end
    end
  end
end