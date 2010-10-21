module Restfulie::Client
  module Feature
    
    module Base
      
      def at(uri)
        @uri = uri
        self
      end
      
      def get
        request_flow
      end
      
    end
    
    class BaseRequest
      
      def execute(flow, request)
        flow.continue(request)
      end
      
    end
    
  end
end