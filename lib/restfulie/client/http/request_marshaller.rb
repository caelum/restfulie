module Restfulie
  module Client
    module HTTP

      class RequestMarshaller < MasterDelegator
        
        attr_reader :acceptable_mediatypes

        def initialize(requester)
          @requester = requester
          @requester.response_handler= Restfulie::Client::Response::CacheHandler.new(@requester.response_handler)
          @requester.response_handler= Restfulie::Client::Response::CreatedRedirect.new(self, @requester.response_handler)
        end
    
      end
    end
  end
end
