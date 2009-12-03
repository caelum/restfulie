require 'jeokkarak'

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
  def self.from_hash(h)
    CustomHash.new(h)
  end
  def self.to_object(h)
    CustomHash.new(h)
  end
end