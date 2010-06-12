module Restfulie
  module Server
    module ActionController #:nodoc:
      if defined?(::ActionController) || defined?(::ApplicationController)
        autoload :ParamsParser, 'restfulie/server/action_controller/params_parser'
        autoload :CacheableResponder, 'restfulie/server/action_controller/cacheable_responder'
        autoload :CreatedResponder, 'restfulie/server/action_controller/created_responder'
        autoload :RestfulResponder, 'restfulie/server/action_controller/restful_responder'
        autoload :Base, 'restfulie/server/action_controller/base'
      end
    end
  end
end

require 'restfulie/server/action_controller/patch'
