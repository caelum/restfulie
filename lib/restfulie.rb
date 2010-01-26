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

require 'restfulie/logger'

require 'net/http'
require 'uri'
require 'vendor/jeokkarak/jeokkarak'

require 'restfulie/media_type'

require 'restfulie/client'
require 'restfulie/server'

require 'restfulie/unmarshalling'

# Author:: Guilherme Silveira (mailto:guilherme.silveira@caelum.com.br)

# This module controls global options for the Restfulie framework.
module Restfulie
  
  # Sets this class as a restfulie class.
  # You may pass a block defining your own transitions.
  #
  # The transitions added will be concatenated with any extra transitions provided by your resource through
  # the use of state and transition definitions.
  # For every transition its name is the only mandatory field:
  # options = {}
  # [:show, options] # will generate a link to your controller's show action
  #
  # The options can be used to override restfulie's conventions:
  # options[:rel] = "refresh" # will create a rel named refresh
  # options[:action] = "destroy" # will link to the destroy method
  # options[:controller] = another controller # will use another controller's action
  #
  # Any extra options will be passed to the target controller url_for method in order to retrieve
  # the transition's uri.
  def acts_as_restfulie
    extend Restfulie::Server::Base
    extend Restfulie::MediaTypeControl
    include Restfulie::Server::Instance
    include Restfulie::Server::Marshalling
    extend Restfulie::Unmarshalling #TODO still needs testing. e.g. server model has from_xml
    #TODO and need to test (de)serialization with both AR and no-AR
    
    self.send :define_method, :following_transitions do
      transitions = []
      yield( self, transitions ) if block_given?
      transitions
    end
  end

end

Object.extend Restfulie

include ActiveSupport::CoreExtensions::Hash