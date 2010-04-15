require 'restfulie/common'

module Restfulie::Client; end

%w(
  http
  configuration
  base
).each do |file|
  require "restfulie/client/#{file}"
end

