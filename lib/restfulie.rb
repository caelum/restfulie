require 'net/http'
require 'uri'
require 'restfulie/marshalling'
require 'restfulie/transition'
require 'restfulie/unmarshalling'

module Restfulie
  
  include Restfulie::Marshalling
  include Restfulie::Transitions

  # checks if its possible to execute such transition and executes it
  def move_to(name)
    raise "Current state #{status} is invalid in order to execute #{name}. It must be one of #{transitions}" unless available_transitions[:allow].include? name
    self.class.transitions[name].execute_at result
  end

  # returns a list with extra possible transitions
  # those transitions will be concatenated with any extra transitions provided by your resource through
  # the use of state and transition definitions  
  def following_transitions
    []
  end
  
  module State
    def respond_to?(sym)
      has_state(sym.to_s) || super(sym)
    end

    def has_state(name)
      !@_possible_states[name].nil?
    end
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
    
    # server side
    
    # returns the definition for the transaction
    def self.existing_transitions(name)
      transitions[name]
    end
    
    # returns a hash of all possible transitions: Restfulie::Transition
    def self.transitions
      @transitions ||= {}
    end

    # returns a hash of all possible states
    def self.states
      @states ||= {}
    end

    # adds a new state to the list of possible states
    def self.state(name, options = {})
      options[:allow] = [options[:allow]] unless options[:allow].kind_of? Array
      states[name] = options
    end

    def self.transition(name, options = {}, result = nil, &body)
      
      transition = Transition.new(name, options, result, body)
      transitions[name] = transition

      define_methods_for(self, name, result)
      controller_name = (self.name + "Controller")
    end

    # receives an object and inserts all necessary methods
    # so it can answer to can_??? invocations
    def self.add_states(result, states)
      result._possible_states = {}

      states.each do |state|
        result._possible_states[state["rel"]] = state
        add_state(state)
      end
      result.extend Restfulie::State
      
      result
    end
    
    # retrieves the invoking method's name
    def self.current_method
      caller[0]=~/`(.*?)'/
      $1
    end
    
    
    # translates a response to an object
    def self.from_response(res)
      
      raise "unimplemented content type" if res.content_type!="application/xml"

      hash = Hash.from_xml res.body
      return hash if hash.keys.length == 0
      raise "unable to parse an xml with more than one root element" if hash.keys.length>1
      
      type = hash.keys[0].camelize.constantize
      type.from_xml(res.body)
      
    end
    
    def self.requisition_method_for(overriden_option,name)
      basic_mapping = { :delete => Net::HTTP::Delete, :put => Net::HTTP::Put, :get => Net::HTTP::Get, :post => Net::HTTP::Post}
      defaults = {:destroy => Net::HTTP::Delete, :delete => Net::HTTP::Delete, :cancel => Net::HTTP::Delete,
                  :refresh => Net::HTTP::Get, :reload => Net::HTTP::Get, :show => Net::HTTP::Get, :latest => Net::HTTP::Get}

      return basic_mapping[overriden_option.to_sym] if overriden_option
      defaults[name.to_sym] || Net::HTTP::Post
    end
    
    
    def self.add_state(transition)
      name = transition["rel"]
      
      self.module_eval do
        
        def temp_method(options = {}, &block)
          self.invoke_remote_transition(self.class.current_method, options, block)
        end
        
        alias_method name, :temp_method
        undef :temp_method
      end
    end  
      
    def self.define_methods_for(type, name, result) 

      return nil if type.respond_to?(name)

      type.send(:define_method, name) do |*args|
        self.status = result.to_s unless result == nil
      end

      type.send(:define_method, "can_#{name}?") do
        transitions = available_transitions[:allow]
        transitions.include? name
      end

    end


    def self.from_web(uri)
      res = Net::HTTP.get_response(URI.parse(uri))
      # TODO redirect... follow or not? (optional...)
      raise "invalid request" if res.code != "200"
      
      # TODO really support different content types
      case res.content_type
      when "application/xml"
        self.from_xml res.body
      when "application/json"
        self.from_json res.body
      else
        raise "unknown content type"
      end
      
    end

  end
end
