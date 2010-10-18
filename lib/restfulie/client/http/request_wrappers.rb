module Restfulie
  module Client
    module HTTP #:nodoc:
      #=A composition (deprecated)
      class RequestFollowExecutor < MasterDelegator
        def initialize
          @requester = RequestFollow.new(HeadersDsl.new(VerbRequest.new(RequestAdapter.new)))
        end
      end
    end
  end
end

module Restfulie
  module Client
    module HTTP #:nodoc:
      #=This class inherits RequestFollowExecutor and include RequestHistory module.
      class RequestHistoryExecutor < RequestBuilderExecutor
        include RequestHistory
      end
    end
  end
end

module Restfulie
  module Client
    module HTTP
      #=This class includes RequestBuilder module.
      class RequestMarshallerExecutor < RequestHistoryExecutor
        include RequestMarshaller
      end
    end
  end
end

module Restfulie
  module Client
    module HTTP #:nodoc:
      #=This class includes RequestBuilder module.
      class RequestBuilderExecutor < RequestExecutor
        include RequestHeaders

        def host=(host)
          super
          at(self.host.path)
        end

        def at(path)
          @path = path
          self
        end

        def path
          @path
        end
      end
    end
  end
end
