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
      return if !respond_to?(:status)
      following_states = self.class._transitions_for(status)
      return if following_states.nil?
      following_states[:allow].each do |name|
        action = self.class._transitions(name)
        action[:action] ||= name
        rel = action[:action]
        if action[:rel]
          rel = action[:rel]
          action[:rel] = nil
        end
        translate_href = controller.url_for(action)
        if options[:use_name_based_link]
          xml.tag!(rel, translate_href)
        else
          xml.tag!('atom:link', 'xmlns:atom' => 'http://www.w3.org/2005/Atom', :rel => rel, :href => translate_href)
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
    attr_accessor :_came_from
    
    def self._transitions_for(state)
      @@states[state]
    end
    
    def self._transitions(name)
      @@transitions[name]
    end
    
    @@states = {}
    @@transitions = {}
    
    def self.state(name, options)
      if name.class==Array
        name.each do |simple|
          self.state(simple, options)
        end
      else
        options[:allow] = [options[:allow]] unless options[:allow].class == Array
        @@states[name] = options
      end
    end

    def self.transition(name, options = {}, result = nil)
      @@transitions[name] = options
      result ||= name
      self.send(:define_method, name) do
        self.status = result
      end
    end

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
        self.module_eval do
          def current_method
            caller[0]=~/`(.*?)'/
            $1
          end
          def temp_method(options = {}, &block)
            name = current_method
            state = _possible_states[name]
            data = options[:data] || {}
            url = URI.parse(state["href"])
            get = false

            # gs: i dont know how to meta play here! i suck
            if options[:method]=="delete"
              req = Net::HTTP::Delete.new(url.path)
            elsif options[:method]=="put"
              req = Net::HTTP::Put.new(url.path)
            elsif options[:method]=="get"
              req = Net::HTTP::Get.new(url.path)
              get = true
            elsif options[:method]=="post"
              req = Net::HTTP::Post.new(url.path)
            elsif ['destroy','delete','cancel'].include? name
              req = Net::HTTP::Delete.new(url.path)
            elsif ['refresh', 'reload', 'show', 'latest'].include? name
              req = Net::HTTP::Get.new(url.path)
              get = true
            else
              req = Net::HTTP::Post.new(url.path)
            end

            req.set_form_data(data)
            req.add_field("Accept", "text/xml") if _came_from == :xml

            http = Net::HTTP.new(url.host, url.port)
            response = http.request(req)
            return yield(response) if !block.nil?
            if get
              case response.content_type
              when "application/xml"
                content = response.body
                hash = Hash.from_xml content
                return hash if hash.keys.length == 0
                raise "unable to parse an xml with more than one root element" if hash.keys.length>1
                key = hash.keys[0]
                type = key.camelize.constantize
                return type.from_xml content
              else
                raise :unknown_content_type
              end
            end
            response

          end
          alias_method name, :temp_method
          undef :temp_method
        end
      end
      
      result
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

    # basic code from Matt Pulver
    # found at http://www.xcombinator.com/2008/08/11/activerecord-from_xml-and-from_json-part-2/
    # addapted to support links
    def self.from_hash( hash )
      h = {}
      h = hash.dup if hash
      links = nil
      h.each do |key,value|
        case value.class.to_s
        when 'Array'
          if key=="link"
            links = h[key]
            h.delete("link")
          else
            h[key].map! { |e| reflect_on_association(key.to_sym ).klass.from_hash e }
          end
        when /\AHash(WithIndifferentAccess)?\Z/
          if key=="link"
            links = [h[key]]
            h.delete("link")
          else
            h[key] = reflect_on_association(key.to_sym ).klass.from_hash value
          end
        end
        h.delete("xmlns") if key=="xmlns"
      end
      result = self.new h
      add_states(result, links) unless links.nil?
      result
    end

    def self.from_json( json )
      from_hash safe_json_decode( json )
    end

    # The xml has a surrounding class tag (e.g. ship-to),
    # but the hash has no counterpart (e.g. 'ship_to' => {} )
    def self.from_xml( xml )
      hash = Hash.from_xml xml
      head = hash[self.to_s.underscore]
      result = self.from_hash head
      return nil if result.nil?
      result._came_from = :xml
      result
    end
  end
end

def safe_json_decode( json )
  return {} if !json
  begin
    ActiveSupport::JSON.decode json
  rescue ; {} end
end
# end of code based on Matt Pulver's