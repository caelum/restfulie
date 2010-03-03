require 'restfulie/common'

#initialize namespace
module Restfulie::Client; end

%w(
  http
  configuration
  response_body_handler
  entry_point
  base
).each do |file|
  require "restfulie/client/#{file}"
end

