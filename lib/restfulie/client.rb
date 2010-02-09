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

require 'restfulie/client/core_ext/hash.rb'

require 'restfulie/client/base'
require 'restfulie/client/entry_point'
require 'restfulie/client/config'

require 'restfulie/client/helper'
require 'restfulie/client/request_execution'
require 'restfulie/client/state'
require 'restfulie/client/atom_media_type'

require 'restfulie/client/cache/basic'
require 'restfulie/client/cache/fake'
require 'restfulie/client/cache/restrictions'

Object.extend Restfulie::Client::Base

include ActiveSupport::CoreExtensions::Hash

class Hashi::CustomHash
    uses_restfulie
end

Restfulie::Client::Base.cache_provider = Restfulie::Client::Cache::Basic.new
