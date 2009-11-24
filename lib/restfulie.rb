require 'net/http'
require 'uri'
require 'restfulie/unmarshalling'

require 'restfulie/client/base'
require 'restfulie/client/helper'
require 'restfulie/client/instance'

require 'restfulie/server/base'
require 'restfulie/server/controller'
require 'restfulie/server/instance'
require 'restfulie/server/marshalling'
require 'restfulie/server/state'
require 'restfulie/server/transition'

module Restfulie
  
  include Restfulie::Server::Marshalling

  # checks if its possible to execute such transition and, if it is, executes it
  def move_to(name)
    raise "Current state #{status} is invalid in order to execute #{name}. It must be one of #{transitions}" unless available_transitions[:allow].include? name
    self.class.transitions[name].execute_at result
  end

  # returns a list of available transitions for this objects state
  # TODO rename because it should never be used by the client...
  def available_transitions
    status_available = respond_to?(:status) && status!=nil
    return {:allow => []} unless status_available
    self.class.states[self.status.to_sym] || {:allow => []}
  end

end

module ActiveRecord
  
  class Base

    include Restfulie
    
  end
end

class Class
  def acts_as_restfulie
    class << self
      include Restfulie::Client::Base
      include Restfulie::Server::Base
    end
    include Restfulie::Server::Instance
    include Restfulie::Client::Instance
  end
end