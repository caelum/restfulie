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
    
    attr_reader :internal_hash

    def initialize(hash = {})
      @internal_hash = hash
    end
    
    def method_missing(name, *args, &block)
      name = name.to_s if name.kind_of? Symbol
      if name[-1,1] == "?"
        parse(name, @internal_hash[name.chop])
      elsif name[-1,1] == "="
        @internal_hash[name.chop] = args[0]
      elsif @internal_hash.kind_of?(Array) && name == "each"
        @internal_hash.each do |k| block.call(transform(k)) end
      elsif name.respond_to? name
        @internal_hash.send(name, *args, &block)
      else
        return nil if @internal_hash.has_key?(name) && @internal_hash[name].nil?
        parse(name, transform(@internal_hash[name]))
      end
    end
    
    def respond_to?(symbol)
      super(symbol) || (@internal_hash.respond_to?(:key?) && @internal_hash.key?(symbol.to_s))
    end
    
    def [](x)
      return CustomHash.new(@internal_hash.values.first)[x] if @internal_hash.length==1 && @internal_hash.values.first.kind_of?(Array)
      transform(@internal_hash[x])
    end
    
    private
    def transform(value)
      return CustomHash.new(value) if value.kind_of?(Hash) || value.kind_of?(Array)
      value
    end
    
    def parse(name, value)
      raise Hashi::UndefinedMethod.new("undefined method '#{name}'") if value.nil?
      value
    end
    
  end
  
  def self.from_hash(hash)
    CustomHash.new(hash)
  end
  
  def self.to_object(hash)
    CustomHash.new(hash)
  end
  
end