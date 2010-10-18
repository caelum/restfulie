module Restfulie
  module Client
    module HTTP #:nodoc:
      #=A composition (deprecated)
      class RequestFollowExecutor < MasterDelegator
        def initialize
          @requester = RequestFollow.new(HeadersDsl.new(VerbRequest.new(RequestAdapter.new)))
        end
      end

      #=A composition (deprecated)
      class RequestHistoryExecutor < MasterDelegator
        def initialize
          @requester = RequestHistory.new(HeadersDsl.new(VerbRequest.new(RequestAdapter.new)))
        end
      end

      #=A composition (deprecated)
      class RequestMarshallerExecutor < MasterDelegator
        def initialize
          @requester = RequestMarshaller.new(RequestHistory.new(HeadersDsl.new(VerbRequest.new(RequestAdapter.new))))
        end
      end

      #=A composition (deprecated)
      class RequestBuilderExecutor < MasterDelegator
        def initialize
          @requester = HeadersDsl.new(VerbRequest.new(RequestAdapter.new))
        end
    end
  end
end
