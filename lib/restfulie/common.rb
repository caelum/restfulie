require 'net/http'
require 'uri'

require 'rubygems'
require 'active_support'
require 'action_controller'

require 'vendor/atom'

module Restfulie
  module Common; end
end

%w(
  errors
  logger
  builder
  representation
).each do |file| 
  require "restfulie/common/#{file}"
end

include ActiveSupport::CoreExtensions::Hash
