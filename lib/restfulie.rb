require 'net/http'
require 'uri'
require 'restfulie/base'
require 'restfulie/helper'
require 'restfulie/marshalling'
require 'restfulie/state'
require 'restfulie/transition'
require 'restfulie/unmarshalling'

module Restfulie
  
  include Restfulie::Marshalling
  include Restfulie::Transitions

  # checks if its possible to execute such transition and, if it is, executes it
  def move_to(name)
    raise "Current state #{status} is invalid in order to execute #{name}. It must be one of #{transitions}" unless available_transitions[:allow].include? name
    self.class.transitions[name].execute_at result
  end

  # Returns an array with extra possible transitions.
  # Those transitions will be concatenated with any extra transitions provided by your resource through
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
  def following_transitions
    []
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
      t = Transition.new(t[0], t[1], t[2], nil) if t.kind_of? Array
      all << t
    end
    all
  end

end

module ActiveRecord
  
  class Base

    include Restfulie
    
    # client side
    
    # list of possible states to access
    attr_accessor :_possible_states
    
    # which content-type generated this data
    attr_accessor :_came_from
    
  end
end
   
