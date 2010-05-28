module Restfulie
  module Client
    module HTTP#:nodoc:
      autoload :Error, 'restfulie/client/http/error'
      autoload :Response, 'restfulie/client/http/response'
      autoload :ResponseHandler, 'restfulie/client/http/response_handler'
      autoload :RequestAdapter, 'restfulie/client/http/request_adapter'
      autoload :RequestBuilder, 'restfulie/client/http/request_builder'
      autoload :RequestFollow, 'restfulie/client/http/request_follow'
      autoload :RequestHistory, 'restfulie/client/http/request_history'
      autoload :RequestExecutor, 'restfulie/client/http/request_executor'
      autoload :RequestBuilderExecutor, 'restfulie/client/http/request_builder_executor'
      autoload :RequestFollowExecutor, 'restfulie/client/http/request_follow_executor'
      autoload :RequestHistoryExecutor, 'restfulie/client/http/request_history_executor'
      autoload :Cache, 'restfulie/client/http/cache'
      autoload :ResponseHolder, 'restfulie/client/http/response_holder'
      autoload :RequestMarshaller, 'restfulie/client/http/request_marshaller'
      autoload :LinkRequestBuilder, 'restfulie/client/http/link_request_builder'
      autoload :RequestMarshallerExecutor, 'restfulie/client/http/request_marshaller_executor'
    end
  end
end

