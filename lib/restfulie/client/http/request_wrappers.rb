module Restfulie
  module Client
    module HTTP #:nodoc:
      #=A composition (deprecated)
      class RequestFollowExecutor < MasterDelegator
        def initialize
          @requester = Restfulie.using {
            verb_request
            follow_links
            headers_dsl
          }
        end
      end

      #=A composition (deprecated)
      class RequestHistoryExecutor < MasterDelegator
        def initialize
          @requester = Restfulie.using {
            verb_request
            request_history
            headers_dsl
          }
        end
      end

      #=A composition (deprecated)
      class RequestMarshallerExecutor < MasterDelegator
        def initialize
          @requester = Restfulie.using {
            verb_request
            request_marshaller
            request_history
            headers_dsl
          }
        end
      end

      #=A composition (deprecated)
      class RequestBuilderExecutor < MasterDelegator
        def initialize
          @requester = Restfulie.using {
            verb_request
            headers_dsl
          }
        end
    end
  end
end
