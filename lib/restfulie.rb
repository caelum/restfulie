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
  
  def invoke_remote_transition(name, options, block)
    
    method = self.class.requisition_method_for options[:method], name

    url = URI.parse(_possible_states[name]["href"])
    req = method.new(url.path)
    req.body = options[:data] if options[:data]
    req.add_field("Accept", "application/xml") if _came_from == :xml

    response = Net::HTTP.new(url.host, url.port).request(req)

    return block.call(response) if block
    return response if method != Net::HTTP::Get
    self.class.from_response response
  end
  
  # returns a list of available transitions for this objects state
  # TODO rename because it should never be used by the client...
  def available_transitions
    status_available = respond_to?(:status) && status!=nil
    return {:allow => []} unless status_available
    self.class.states[self.status.to_sym] || {:allow => []}
  end

  # returns a list containing all available transitions for this object's state
  def all_following_transitions
    all = [] + available_transitions[:allow]
    following_transitions.each do |t|
      t = Restfulie::Server::Transition.new(t[0], t[1], t[2], nil) if t.kind_of? Array
      all << t
    end
    all
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