if defined?(::ActionController) && defined?(::ApplicationController)

  module Restfulie::Server::ActionController#:nodoc:
  end

  %w(
    restful_responder
    base
    routing
  ).each do |file|
    require "restfulie/server/action_controller/#{file}"
  end

end

