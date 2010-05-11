require 'net/http'
require 'uri'

require 'rubygems'
require 'active_support'
require 'action_controller'

module Restfulie
  module Common; end
end

%w(
  errors
  logger
  core_ext
  representation
  converter
).each do |file| 
  require "restfulie/common/#{file}"
end

include ActiveSupport::CoreExtensions::Hash
