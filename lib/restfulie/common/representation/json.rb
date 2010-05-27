module Restfulie::Common::Representation

  class JSON
    
    class << self
      def create(obj = nil)
        @json = {}
        return @json.extend(JSONKeysAsMethods) unless obj
        
        if obj.kind_of?(Hash) || obj.kind_of?(Array)
          @json = obj
        else 
          @json = ::JSON.parse(obj)
        end
        
        @json.extend(JSONKeysAsMethods)
      end
    end
    
  end
  
  module JSONKeysAsMethods

    # overriding the already deprecated method :type
    alias_method :__type__, :type
    def type
      method_missing(:type)
    end
    
    def [](key)
      __normalize__(super(key))
    end

    def []=(key, value)
      super(key,value)
    end

    def to_s
      super.to_json
    end

    def method_missing(name, *args)
      method_name = name.to_s
      if method_name.last == '='
        self[method_name.chop] = args[0]
      else
        self[method_name]
      end
    end

    # if you have a key that is also a method (such as Array#size) 
    # you can use this to free the method and use the method obj.size
    # to access the value of key "size".
    # you still can access the old method with __[method_name]__
    def __free_method__(sym)
      self.class.send(:alias_method, "__#{sym.to_s}__".to_sym, sym)
      self.class.send(:define_method, sym) { method_missing(sym.to_s) }
      self
    end

  private

    def __normalize__(value)
      case value
      when Hash
        value.extend(JSONKeysAsMethods)
      when Array
        value.map { |v| __normalize__(v) }
      else
        value
      end
      value
    end
    
  end
  
end
