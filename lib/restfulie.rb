require 'net/http'
require 'uri'

module Restfulie
  def to_json
    super :methods => :following_states
  end

  def to_xml(options = {})
    controller = options[:controller]
    return super if controller.nil?
    
    options[:skip_types] = true
    super options do |xml|
      if respond_to?(:following_states)
        states = following_states
        states = [states] if states.class.to_s != 'Array'
        states.each do |action|
          rel = action[:rel] || action[:action]
          translate_href = controller.url_for(action)
          if options[:use_name_based_link]
            xml.tag!(rel, translate_href)
          else
            xml.tag!('atom:link', 'xmlns:atom' => 'http://www.w3.org/2005/Atom', :rel => rel, :href => translate_href)
          end
        end
      end
    end
  end

  def create_method(name, &block)
    self.class.send(:define_method, name, &block)
  end


end

module ActiveRecord
  class Base

    include Restfulie
    attr_accessor :_possible_states

    def self.add_states(result, states)
      result._possible_states = {}
      states.each do |state|
        result._possible_states[state["rel"]] = state
      end
      def result.respond_to?(sym)
        has_state(sym.to_s) || super(sym)
      end

      def result.has_state(name)
        !@_possible_states[name].nil?
      end
      
      states.each do |state|
        name = state["rel"]
        result.create_method(name){ |options|
          options = {} if options.nil?
          url = URI.parse(state["href"])
          if ['destroy','delete','cancel'].include? name
            method_name = "delete"
          elsif ['refresh', 'reload'].include? name
            method_name = "get"
          else
            method_name = "post"
          end
          method_name = options[:method] if options[:method]
          res = Net::HTTP.send(method_name, url)
          return res
        }
      end
      
      result
    end

    # basic code from Matt Pulver
    # found at http://www.xcombinator.com/2008/07/06/activerecord-from_json-and-from_xml/
    # addapted to support links
    def self.from_hash( hash )
      h = hash.dup
      links = nil
      h.each do |key,value|
          case value.class.to_s
          when 'Array'
            if key=="link"
              links = h[key]
              h.delete("link")
            else
              h[key].map! { |e|
                Object.const_get(key.camelize.singularize).from_hash e }
            end
          when 'Hash'
            if key=="link"
              links = [h[key]]
              h.delete("link")
            else
              h[key] = Object.const_get(key.camelize).from_hash value
            end
          end
      end
      result = self.new h
      add_states(result, links) unless links.nil?
    end

    def self.from_json( json )
      hash = ActiveSupport::JSON.decode json
      self.from_hash hash
    end

    # The xml has a surrounding class tag (e.g. ship-to),
    # but the hash has no counterpart (e.g. 'ship_to' => {} )
    def self.from_xml( xml )
      hash = Hash.from_xml xml
      self.from_hash hash[self.to_s.underscore]
    end

    # end of code based on Matt Pulver's
  end
  
end
