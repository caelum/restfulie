require 'restfulie'

module Restfulie
  module Resource
    def from_hash(hash)
      instance = Hashi.to_object(hash)
    end
  end
end

module Hashi
  class UndefinedMethod
  end
  class CustomHash
    
    attr_reader :hash

    def initialize(h)
      @hash = h
    end
    def method_missing(name, *args)
      name = name.to_s if name.kind_of? Symbol
      if name[-1,1] == "?"
        parse(@hash[name.chop])
      elsif name[-1,1] == "="
        @hash[name.chop] = args[0]
      else
        parse(transform(@hash[name]))
      end
    end
    def [](x)
      transform(@hash[x])
    end
    private
    def transform(value)
      return CustomHash.new(value) if value.kind_of?(Hash) || value.kind_of?(Array)
      value
    end
    def parse(val)
      raise Hashi::UndefinedMethod.new if val.nil?
      val
    end
    
  end
  def self.to_object(h)
    CustomHash.new(h)
  end
end
module Hashi
  class CustomHash
    uses_restfulie
    def initialize(h)
      @hash = h
      link = h['link']
      add_transitions([link]) if link.kind_of? Hash
      add_transitions(link) if link.kind_of? Array
    end
    def method_missing(name, *args)
      super(name, args)
    end
  end
end

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
