module Restfulie
  module Client
    module HTTP #:nodoc:
      #=A composition (deprecated)
      class RequestFollowExecutor < MasterDelegator
        def initialize(host)
          @requester = Restfulie.using {
            follow_link
            verb_request
          }.at(host)
        end
      end

      #=A composition (deprecated)
      class RequestHistoryExecutor < MasterDelegator
        def initialize(host)
          @requester = Restfulie.using {
            # recipe
            # follow_link
            # request_marshaller
            # verb_request
            request_history
            verb_request
          }.at(host)
        end
      end

      #=A composition (deprecated)
      class RequestMarshallerExecutor < MasterDelegator
        def initialize(host)
          @requester = Restfulie.using {
            request_marshaller
            request_history
            verb_request
          }.at(host)
        end
      end

      #=A composition (deprecated)
      class RequestBuilderExecutor < MasterDelegator
        def initialize(host)
          @requester = Restfulie.using {
            verb_request
          }.at(host)
        end
      end
    end
  end
end
