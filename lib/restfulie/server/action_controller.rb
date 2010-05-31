module Restfulie
  module Server
    module ActionController #:nodoc:
      if defined?(::ActionController) || defined?(::ApplicationController)
        autoload :ParamsParser, 'restfulie/server/action_controller/params_parser'
        autoload :RestfulResponder, 'restfulie/server/action_controller/restful_responder'
        autoload :Base, 'restfulie/server/action_controller/base'
      end
    end
  end
end

require 'restfulie/server/action_controller/patch'
