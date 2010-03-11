require 'restfulie/common'

module Restfulie::Server#:nodoc:
end

%w(
  configuration
  action_pack
  active_record
  core_ext
  restfulie_controller
).each do |file|
  require "restfulie/server/#{file}"
end

