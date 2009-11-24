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
    include Restfulie::Client::Instance
    include Restfulie::Server::Instance
    include Restfulie::Server::Marshalling
  end
end