module Restfulie::Server::ActionController#:nodoc:

  if defined?(::ActionController) || defined?(::ApplicationController)

    %w(
      params_parser
      restful_responder
      base
      routing
    ).each do |file|
      autoload file.camelize.to_sym, "restfulie/server/action_controller/#{file}"
    end

  end
end
