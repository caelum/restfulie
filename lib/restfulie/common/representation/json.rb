module Restfulie::Common::Representation

  class Json
    
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

    def self.extended(base)
      [:type, :id].each { |m| base.__free_method__(m) }      
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
      self.__metaclass__.send(:alias_method, "__#{sym.to_s}__".to_sym, sym) unless self.respond_to?("__#{sym.to_s}__")
      self.__metaclass__.send(:define_method, sym) { method_missing(sym.to_s) }
      self
    end

    def __metaclass__
      class << self; self; end
    end
    
    # easy accessors to links
    def links
      some_links = self["link"]
      return nil unless some_links
      some_links = [some_links] unless some_links.kind_of? Array
      JsonLinkCollection.new(some_links)
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
  
  class JsonLinkCollection
    def initialize(parent_node)
      @node = parent_node
    end
    
    def method_missing(symbol, *args, &block)
      linkset = @node.select {|link| link.rel == symbol.to_s }
      linkset.map! { |link| JsonLink.new(link) }
      unless linkset.empty?
        linkset.size == 1 ? linkset.first : linkset
      else
        nil
      end
    end
  end
  
  class JsonLink
    def initialize(obj)
      @obj = obj
    end
    
    def type
      @obj.type
    end
    
    def href
      @obj.href
    end
    
    def rel
      @obj.rel
    end
        
    def method_missing(symbol, *args, &block)
      @obj.send(symbol, *args, &block)
    end
  end
    
end
