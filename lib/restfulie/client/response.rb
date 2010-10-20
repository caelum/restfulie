module Restfulie
  module Client
    module Response#:nodoc:
      autoload :EnhanceResponse, 'restfulie/client/response/enhance_response'
      autoload :IgnoreError, 'restfulie/client/response/ignore_error'
      autoload :CatchAndThrow, 'restfulie/client/response/catch_and_throw'
    end
  end
end
