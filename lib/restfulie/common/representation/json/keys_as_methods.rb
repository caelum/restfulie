module Restfulie
  module Common
    module Representation
      class Json
        module KeysAsMethods
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
            if self.__metaclass__.method_defined?(sym) && !respond_to?("__#{sym}__")
              self.__metaclass__.send(:alias_method, "__#{sym}__", sym)
            end
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
            LinkCollection.new(some_links)
          end
              
        private
      
          def __normalize__(value)
            case value
            when Hash
              value.extend(KeysAsMethods)
            when Array
              value.map { |v| __normalize__(v) }
            else
              value
            end
            value
          end
        end
      end
    end
  end
end
