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
