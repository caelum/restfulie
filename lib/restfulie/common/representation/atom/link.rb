module Restfulie
  module Common
    module Representation
      module Atom
        class Link < XML    
          def initialize(options_or_obj)
            if options_or_obj.kind_of?(Hash)
              @doc = Nokogiri::XML::Document.new()
              options_or_obj = create_element("link", options_or_obj)
            end
            super(options_or_obj)
          end
          
          def href
            @doc["href"]
          end
          
          def href=(value)
            @doc["href"] = value
          end
          
          def rel
            @doc["rel"]
          end
          
          def rel=(value)
            @doc["rel"] = value
          end
      
          if method_defined?(:type)
            alias_method :__type__, :type
          end
          def type
            @doc["type"]
          end
          
          def type=(value)
            @doc["type"] = value
          end
      
          def hreflang
            @doc["hreflang"]
          end
          
          def hreflang=(value)
            @doc["hreflang"] = value
          end
      
          def title
            @doc["title"]
          end
          
          def title=(value)
            @doc["title"] = value
          end
          
          def length
            @doc["length"]
          end
          
          def length=(value)
            @doc["length"] = value
          end
        end
      end
    end
  end
end
