module Restfulie
  module Resource
    def from_hash(hash)
      instance = Hashi.to_object(hash)
    end
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

module Jeokkarak
  module Base
    alias_method :old_from_hash_parse, :from_hash_parse
    def from_hash_parse(result,h,key,value)
      return old_from_hash_parse(result, h, key, value) if key!='link'
      link = h[key]
      result.add_transitions([link]) if link.kind_of? Hash
      result.add_transitions(link) if link.kind_of? Array
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
