module Restfulie
  module Client
    module HTTP #:nodoc:
      #=This class includes RequestBuilder module.
      class RequestBuilderExecutor < RequestExecutor
        include RequestBuilder
  
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
