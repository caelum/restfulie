if defined? ::ActionController 

  module Restfulie::Server::ActionController#:nodoc:
  end

  %w(
    base
    routing
  ).each do |file|
    require "restfulie/server/action_controller/#{file}"
  end

end

