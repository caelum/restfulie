require 'restfulie/common'
require 'responders_backport'

module Restfulie::Server#:nodoc:
end

%w(
  configuration
  action_controller
  action_view
  core_ext
  unmarshal
  restfulie_controller
).each do |file|
  require "restfulie/server/#{file}"
end

