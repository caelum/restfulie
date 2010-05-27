module Restfulie
  module Client
    module HTTP #:nodoc:
      #=This class includes RequestAdapter module.
      class RequestExecutor
        include RequestAdapter
  
        # * <tt> host (e.g. 'http://restfulie.com') </tt>
        # * <tt> default_headers  (e.g. {'Cache-control' => 'no-cache'} ) </tt>
        def initialize(host, default_headers = {})
          self.host=host
          self.default_headers=default_headers
        end
      end
    end
  end
end
