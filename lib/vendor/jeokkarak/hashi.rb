module Hashi
  class UndefinedMethod < Exception
    attr_reader :msg
    def initialize(msg)
      @msg = msg
    end
    def to_s
      @msg
    end
  end
  
  class CustomHash
    
    attr_reader :hash
 
    def initialize(h = {})
      @hash = h
    end
    
    def method_missing(name, *args)
      name = name.to_s if name.kind_of? Symbol
      if name[-1,1] == "?"
        parse(name, @hash[name.chop])
      elsif name[-1,1] == "="
        @hash[name.chop] = args[0]
      else
        return nil if @hash.has_key?(name) && @hash[name].nil?
        parse(name, transform(@hash[name]))
      end
    end
    
    def respond_to?(symbol)
      @hash.key? symbol.to_s
    end
    
    def [](x)
      transform(@hash[x])
    end
    
    private
    def transform(value)
      return CustomHash.new(value) if value.kind_of?(Hash) || value.kind_of?(Array)
      value
    end
    
    def parse(name, val)
      raise Hashi::UndefinedMethod.new("undefined method '#{name}'") if val.nil?
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
