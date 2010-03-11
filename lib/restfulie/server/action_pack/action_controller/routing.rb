module Restfulie::ActionController::Routing#:nodoc:
end

require 'restfulie/server/action_pack/action_controller/routing/restfull_route'

ActionController::Routing::RouteSet.send :include,
  Restfulie::ActionController::Routing::Route

ActionController::Routing::Route.send :include,
  Restfulie::ActionController::Routing::Route


