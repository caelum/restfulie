if defined? ActionController 

  module Restfulie::ActionController#:nodoc:
  end

  %w(
    base
    routing
  ).each do |file|
    require "restfulie/server/action_pack/action_controller/#{file}"
  end

end

