require 'net/http'
require 'uri'
require 'jeokkarak'
require 'hashi'

require 'restfulie/client/base'
require 'restfulie/client/entry_point'
require 'restfulie/client/helper'
require 'restfulie/client/instance'
require 'restfulie/client/state'

require 'restfulie/server/base'
require 'restfulie/server/controller'
require 'restfulie/server/instance'
require 'restfulie/server/marshalling'
require 'restfulie/server/transition'

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
    include Restfulie::Server::Instance
    include Restfulie::Server::Marshalling
    
    self.send :define_method, :following_transitions do
      transitions = []
      yield( self, transitions ) if block_given?
      transitions
    end
  end
  
  def uses_restfulie
    extend Restfulie::Client::Base
    include Restfulie::Client::Instance
    extend Restfulie::Unmarshalling
  end
end

Object.extend Restfulie

require 'restfulie/conversions'
require 'restfulie/unmarshalling'
