#
#  Copyright (c) 2009 Caelum - www.caelum.com.br/opensource
#  All rights reserved.
# 
#  Licensed under the Apache License, Version 2.0 (the "License"); 
#  you may not use this file except in compliance with the License. 
#  You may obtain a copy of the License at 
#  
#   http://www.apache.org/licenses/LICENSE-2.0 
#  
#  Unless required by applicable law or agreed to in writing, software 
#  distributed under the License is distributed on an "AS IS" BASIS, 
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
#  See the License for the specific language governing permissions and 
#  limitations under the License. 
#

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
  atom_media_type
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
