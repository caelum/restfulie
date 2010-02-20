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

module Restfulie::Server
  # Defines host to be passed to polymorphic_url.
  # You need to setup this to your own domain in order to generate meaningful links.
  mattr_accessor :host
  @@host = 'localhost:3000'
  
  # Passes a symbol to polymorphic_url in order to use a namespaced named_route.
  # So, if config.named_route_prefix = :rest, it will search for rest_album_url,
  # rest_album_songs_url, and so on.
  mattr_accessor :named_route_prefix
  @@named_route_prefix = nil
        
  # This defines a Rails-like way to setup options. You can do, in a initializer:
  #   Restfulie::Server.setup do |config|
  #     config.host = 'mydomain.com'
  #   end
  def self.setup
    yield self
  end
end

#initialize server namespace
module Restfulie::Server; end

%w(
  base
  controller
  instance
  marshalling
  transition
  restfulie_controller
  atom_media_type
  core_ext
  serializers
  rails_ext
).each do |file|
  require "restfulie/server/#{file}"
end

class Object
  extend Restfulie
end
