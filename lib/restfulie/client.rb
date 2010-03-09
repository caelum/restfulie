require 'restfulie/common'

#initialize namespace
module Restfulie::Client#:nodoc:
end

%w(
  http
  configuration
  base
).each do |file|
  require "restfulie/client/#{file}"
end

