module Restfulie
  module Client
    module HTTP#:nodoc:
      autoload :Error, 'restfulie/client/http/error'
      autoload :Response, 'restfulie/client/http/response'
      autoload :ResponseHandler, 'restfulie/client/http/response_handler'
      autoload :RequestAdapter, 'restfulie/client/http/request_adapter'
      autoload :HeadersDsl, 'restfulie/client/http/headers_dsl'
      autoload :RequestFollow, 'restfulie/client/http/request_follow'
      autoload :RequestHistory, 'restfulie/client/http/request_history'
      autoload :RequestBuilderExecutor, 'restfulie/client/http/request_builder_executor'
      autoload :RequestFollowExecutor, 'restfulie/client/http/request_follow_executor'
      autoload :RequestHistoryExecutor, 'restfulie/client/http/request_history_executor'
      autoload :Cache, 'restfulie/client/http/cache'
      autoload :MasterDelegator, 'restfulie/client/http/master_delegator'
      autoload :ResponseHolder, 'restfulie/client/http/response_holder'
      autoload :RequestMarshaller, 'restfulie/client/http/request_marshaller'
      autoload :LinkRequestBuilder, 'restfulie/client/http/link_request_builder'
      autoload :RequestMarshallerExecutor, 'restfulie/client/http/request_marshaller_executor'
      autoload :VerbRequest, 'restfulie/client/http/verb_request'
    end
  end
end

require 'restfulie/client/ext/atom_ext'
require 'restfulie/client/ext/xml_ext'
require 'restfulie/client/ext/http_ext'
require 'restfulie/client/ext/json_ext'
