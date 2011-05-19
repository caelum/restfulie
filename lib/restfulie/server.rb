require 'respondie'
require 'restfulie/common'

module Restfulie
  module Server
    autoload :Configuration, 'restfulie/server/configuration'
    autoload :ActionController, 'restfulie/server/action_controller'
    autoload :Controller, 'restfulie/server/controller'
  end
end

require 'restfulie/server/hypertemplate'
require 'restfulie/server/core_ext'

if defined? ::ActionController
  class ActionController::Base
    def self.restfulie
      include Restfulie::Server::ActionController::Base
    end
  
    def self.use_trait(&block)
      Respondie::Builder.new("Restfulie::Server::ActionController::Trait::$trait$", self).instance_eval(&block)
    end

  end
end