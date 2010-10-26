module Restfulie
  module Server
    module ActionController #:nodoc:
      if defined?(::ActionController) || defined?(::ApplicationController)
        Dir["#{File.dirname(__FILE__)}/action_controller/*.rb"].each {|f| autoload File.basename(f)[0..-4].camelize.to_sym, f }
      end
    end
  end
end

require 'restfulie/server/action_controller/patch'
