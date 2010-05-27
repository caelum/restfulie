require 'net/http'
require 'uri'

require 'rubygems'
require 'active_support'
require 'action_controller'
require 'restfulie/common/core_ext'

module Restfulie
  module Common
    autoload :Error, 'restfulie/common/error'
    autoload :Logger, 'restfulie/common/logger'
    autoload :Representation, 'restfulie/common/representation'
    autoload :Converter, 'restfulie/common/converter'
  end
end
