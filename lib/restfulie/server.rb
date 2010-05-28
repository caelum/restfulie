require 'restfulie/common'
require 'responders_backport'

module Restfulie
  module Server
    autoload :Configuration, 'restfulie/server/configuration'
    autoload :ActionController, 'restfulie/server/action_controller'
    autoload :ActionView, 'restfulie/server/action_view'
    autoload :Controller, 'restfulie/server/controller'
  end
end

require 'restfulie/server/core_ext'
Restfulie::Server::ActionView::TemplateHandlers.activate!
