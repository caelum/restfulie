require 'net/http'
require 'uri'
#require 'hashi'

require 'restfulie/client/base'
require 'restfulie/client/entry_point'
require 'restfulie/client/helper'
require 'restfulie/client/instance'

require 'restfulie/server/base'
require 'restfulie/server/controller'
require 'restfulie/server/instance'
require 'restfulie/server/marshalling'
require 'restfulie/server/state'
require 'restfulie/server/transition'

module Restfulie
  def acts_as_restfulie
    extend Restfulie::Server::Base
    include Restfulie::Server::Instance
    include Restfulie::Server::Marshalling
    
    self.send :define_method, :following_transitions do
      transitions = []
      yield( transitions ) if block_given?
      transitions
    end
  end
  
  def uses_restfulie
    extend Restfulie::Client::Base
    include Restfulie::Client::Instance
  end
end

Object.extend Restfulie

require 'restfulie/unmarshalling'
