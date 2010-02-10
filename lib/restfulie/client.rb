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

require 'activesupport'
require 'action_controller'
require 'restfulie/logger'

require 'net/http'
require 'uri'
require 'vendor/jeokkarak/jeokkarak'

require 'restfulie/media_type'
require 'restfulie/client/atom_media_type'
require 'restfulie/client/base'
require 'restfulie/client/entry_point'
require 'restfulie/client/helper'
require 'restfulie/client/instance'
require 'restfulie/client/request_execution'
require 'restfulie/client/state'
require 'restfulie/client/cache'
require 'restfulie/unmarshalling'

module Restfulie
  
  class << self
    attr_accessor :cache_provider
  end
  
  # Extends your class to support restfulie-client side's code.
  # This will extends Restfulie::Client::Base methods as class methods,
  # Restfulie::Client::Instance as instance methods and Restfulie::Unmarshalling as class methods.
  def uses_restfulie
    extend Restfulie::Client::Base
    include Restfulie::Client::Instance
    extend Restfulie::Unmarshalling
  end
  
end

Object.extend Restfulie

include ActiveSupport::CoreExtensions::Hash

class Hashi::CustomHash
    uses_restfulie
end

Restfulie.cache_provider = Restfulie::BasicCache.new
