require 'restfulie/common'

#initialize namespace
module Restfulie::Client; end

%w(
  base
  entry_point
  config
  core_ext/hash
  helper
  request_execution
  state
  cache/basic
  cache/fake
  cache/restrictions
).each do |file|
  require "restfulie/client/#{file}"
end

Object.extend Restfulie::Client::Base

include ActiveSupport::CoreExtensions::Hash

class Hashi::CustomHash
    uses_restfulie
end

Restfulie::Client.cache_provider = Restfulie::Client::Cache::Basic.new
