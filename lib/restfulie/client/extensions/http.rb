module Restfulie
  module Client
    
    # an extesion to http responses
    module HTTPResponse
        
      # determines if this response code was successful (according to http specs: 200~299)
      def is_successful?
        code.to_i >= 200 && code.to_i <= 299
      end
        
    end
  end
end
