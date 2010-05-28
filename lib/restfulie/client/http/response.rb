module Restfulie
  module Client
    module HTTP #:nodoc:
      #=Response
      # Default response class
      class Response
        attr_reader :method
        attr_reader :path
        attr_reader :code
        attr_reader :body
        attr_reader :headers

        def initialize(method, path, code, body, headers)
          @method = method
          @path = path
          @code = code
          @body = body 
          @headers = headers
        end
      end
    end
  end
end
