if defined? ::ActionView and ::ActionController
  
  module Restfulie::Server::ActionView #:nodoc:
  end
  
  require 'restfulie/server/action_view/template_handlers'
  require 'restfulie/server/action_view/helpers'
end