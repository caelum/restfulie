module Restfulie
  module Client
    module HTTP #:nodoc:
      #=This class inherits RequestBuilderExecutor and include RequestFollow module.
      class RequestFollowExecutor < RequestBuilderExecutor
        include RequestFollow
      end
    end
  end
end
