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
