module Restfulie
  module Client
    module Response#:nodoc:
      autoload :EnhanceResponse, 'restfulie/client/response/enhance_response'
      autoload :IgnoreError, 'restfulie/client/response/ignore_error'
      autoload :CatchAndThrow, 'restfulie/client/response/catch_and_throw'
      autoload :CacheHandler, 'restfulie/client/response/cache_handler'
      autoload :UnmarshalHandler, 'restfulie/client/response/unmarshal_handler'
    end
  end
end
