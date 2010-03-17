module Restfulie::Server::ActionController::Routing#:nodoc:
end

require 'restfulie/server/action_controller/routing/restful_route'

ActionController::Routing::RouteSet.send :include,
  Restfulie::Server::ActionController::Routing::Route

ActionController::Routing::Route.send :include,
  Restfulie::Server::ActionController::Routing::Route


