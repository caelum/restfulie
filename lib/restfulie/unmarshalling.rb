module ActiveRecord
  class Base

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
      if !(links.nil?) && self.include?(Restfulie::Client::Instance)
        result.add_transitions(links)
      end
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
      result._came_from = :xml if self.include?(Restfulie::Client::Instance)
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

module Restfulie
  class CustomObject
      # def initialize(hash)
      #   hash.each do |k,v|
      #     self.instance_variable_set("@#{k}", v)
      #     self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})
      #     self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})
      #   end
      # end
      # 
      # def save
      #   hash_to_return = {}
      #   self.instance_variables.each do |var|
      #     hash_to_return[var.gsub("@","")] = self.instance_variable_get(var)
      #   end
      #   return hash_to_return
      # end


    def initialize(h)
      @hash = h
    end
    def method_missing(name, *args)
      name = name.to_s if name.kind_of? Symbol
      if name[-1,1] == "="
        name = name.chop
        @hash[name] = args[0]
      else
        transform(@hash[name])
      end
    end
    def [](x)
      transform(@hash[x])
    end
    private
    def transform(value)
      return CustomObject.new(value) if value.kind_of?(Hash) || value.kind_of?(Array)
      value
    end
  end
  def self.hash_to_object(h)
    CustomObject.new(h)
    #   return super(name, args)
    #   return super(name, args) if o.respond_to? name
    #   # array?
    #   h[name]
    # end
  end
  # def self.from_xml
#  values = Hash.from_xml(xml).values
  #   
  #   player.friend.name
  #   
  #   a.b
  #   a["b"]
  #   
  #   from_xml::
  #              typecast_xml_value(unrename_keys(XmlMini.parse(xml)))
  #   self.attributes = .first
  #   self
  # end
  # 
end