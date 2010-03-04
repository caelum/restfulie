require 'restfulie/common'

#initialize namespace
module Restfulie::Client; end

%w(
  http
  configuration
  response_body_handler
  base
).each do |file|
  require "restfulie/client/#{file}"
end

