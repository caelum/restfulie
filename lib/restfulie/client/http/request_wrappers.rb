module Restfulie
  module Client
    module HTTP #:nodoc:
      #=A composition (deprecated)
      class RequestFollowExecutor < MasterDelegator
        def initialize
          @requester = Restfulie.using {
            follow_links
            headers_dsl
            verb_request
          }
        end
      end

      #=A composition (deprecated)
      class RequestHistoryExecutor < MasterDelegator
        def initialize
          @requester = Restfulie.using {
            request_history
            headers_dsl
            verb_request
          }
        end
      end

      #=A composition (deprecated)
      class RequestMarshallerExecutor < MasterDelegator
        def initialize
          @requester = Restfulie.using {
            request_marshaller
            request_history
            headers_dsl
            verb_request
          }
        end
      end

      #=A composition (deprecated)
      class RequestBuilderExecutor < MasterDelegator
        def initialize
          @requester = Restfulie.using {
            headers_dsl
            verb_request
          }
        end
    end
  end
end
