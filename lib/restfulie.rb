require 'net/http'
require 'uri'
require 'marshalling'
require 'transition'
require 'unmarshalling'

module Restfulie
 
  def move_to(name)
    transitions = available_transitions[:allow]
    raise "Current state #{status} is invalid in order to execute #{name}. It must be one of #{transitions}" unless transitions.include? name
    result = self.class._transitions(name).result
    self.status = result.to_s unless result.nil?
  end
  
  module State
    def respond_to?(sym)
      has_state(sym.to_s) || super(sym)
    end

    def has_state(name)
      !@_possible_states[name].nil?
    end
  end
  
end

module ActiveRecord
  
  class Base

    include Restfulie
    attr_accessor :_possible_states
    attr_accessor :_came_from
    
    # returns a list of available transitions for this objects state
    def available_transitions()
      self.class.states[self.status.to_sym]
    end
    
    # returns the definition for the transaction
    def self._transitions(name)
      transitions[name]
    end
    
    # returns a hash of all possible transitions
    def self.transitions
      @transitions ||= {}
    end
    
    # returns a hash of all possible states
    def self.states
      @states ||= {}
    end
    
    def self.state(name, options = {})
      if name.class==Array
        name.each do |simple|
          self.state(simple, options)
        end
      else
        options[:allow] = [options[:allow]] unless options[:allow].class == Array
        states[name] = options
      end
    end

    def self.transition(name, options = {}, result = nil, &body)
      transition = Transition.new(name, options, result, body)
      transitions[name] = transition
      
      define_methods_for(self, name, result)
      controller_name = (self.name + "Controller")
    end

    def self.add_states(result, states)
      result._possible_states = {}
      states.each do |state|
        result._possible_states[state["rel"]] = state
      end
      
      result.extend Restfulie::State
      
      states.each do |state|
        add_state(state)
      end
      
      result
    end
    
    # retrieves the invoking method's name
    def self.current_method
      caller[0]=~/`(.*?)'/
      $1
    end
    
    def self.add_state(state)
      name = state["rel"]
      self.module_eval do
        def temp_method(options = {}, &block)
          name = self.class.current_method
          state = _possible_states[name]
          url = URI.parse(state["href"])
          
          method_from = { :delete => Net::HTTP::Delete,
                          :put => Net::HTTP::Put,
                          :get => Net::HTTP::Get,
                          :post => Net::HTTP::Post}
          defaults = {:destroy => Net::HTTP::Delete, :delete => Net::HTTP::Delete, :cancel => Net::HTTP::Delete,
                    :refresh => Net::HTTP::Get, :reload => Net::HTTP::Get, :show => Net::HTTP::Get, :latest => Net::HTTP::Get}

          req_type = method_from[options[:method].to_sym] if options[:method]
          req_type ||= defaults[name.to_sym] || Net::HTTP::Post
          
          get = req_type==Net::HTTP::Get
          req = req_type.new(url.path)

          req.body = options[:data] if options[:data]
          req.add_field("Accept", "text/xml") if _came_from == :xml

          http = Net::HTTP.new(url.host, url.port)
          response = http.request(req)
          return yield(response) if !block.nil?
          if get
            raise "unimplemented content type" if response.content_type!="application/xml"
            content = response.body
            hash = Hash.from_xml content
            return hash if hash.keys.length == 0
            raise "unable to parse an xml with more than one root element" if hash.keys.length>1
            key = hash.keys[0]
            type = key.camelize.constantize
            return type.from_xml(content)
          end
          response

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
      url = URI.parse(uri)
      req = Net::HTTP::Get.new(url.path)
      http = Net::HTTP.new(url.host, url.port)
      res = http.request(req)
      raise :invalid_request, res if res.code != "200"
      case res.content_type
      when "application/xml"
        self.from_xml res.body
      when "application/json"
        self.from_json res.body
      else
        raise :unknown_content_type
      end
    end

  end
end

