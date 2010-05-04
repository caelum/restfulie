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
  core_ext
  builder
  converter
).each do |file| 
  require "restfulie/common/#{file}"
end

include ActiveSupport::CoreExtensions::Hash
