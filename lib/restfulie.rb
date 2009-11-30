require 'net/http'
require 'uri'
require 'restfulie/unmarshalling'

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

class Class
  def acts_as_restfulie(&block)  
    class << self
      include Restfulie::Server::Base
    end
    
    include Restfulie::Server::Instance
    include Restfulie::Server::Marshalling
    
    self.send :define_method, :following_transitions do
      block.nil? ? [] : block.call
    end
  end
  
  def uses_restfulie
    class << self
      include Restfulie::Client::Base
    end
    include Restfulie::Client::Instance
  end
end