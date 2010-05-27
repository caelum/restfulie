module Restfulie
  module Common
    module Representation
      module Atom
        class Feed < Base
          def initialize(xml_obj = nil)
            @generator = nil
            @entries = nil
            super(xml_obj)
            @reserved = Base::ATOM_ATTRIBUTES[:feed][:required] + Base::ATOM_ATTRIBUTES[:feed][:recommended] + Base::ATOM_ATTRIBUTES[:feed][:optional] + [:entry]
          end
          
          def entries
            unless @entries
              @entries = TagCollection.new(@doc)
              @doc.xpath("xmlns:entry").each do |entry|
                @entries << Entry.new(entry)
              end    
            end
            
            return @entries
          end
        
          # comp: attr: uri, version (optionals); content (mandatory)
          def generator
            unless @generator
              @doc.xpath("xmlns:generator").each do |generator|
                @generator = Generator.new(generator)
              end 
            end
            
            return generator
          end
          
          def generator=(obj)
            @generator = obj
          end
        
          # simple text
          def icon
            text("icon")
          end
      
          def icon=(value)
            set_text("icon", value)
          end
        
          # simple text
          def logo
            text("logo")
          end
      
          def logo=(value)
            set_text("logo", value)
          end
        
          # text
          def subtitle
            text("subtitle")
          end
      
          def subtitle=(value)
            set_text("subtitle", value)
          end
        end
        
        class Generator < XML    
          def initialize(options_or_obj)
            if options_or_obj.kind_of?(Hash)
              @doc = Nokogiri::XML::Document.new()
              node = @doc.create_element("generator")
              node.add_namespace_definition(nil, "http://www.w3.org/2005/Atom")
              node.parent = @doc
              super(node)
              options_or_obj.each do |key,value|
                self.send("#{key}=".to_sym, value)
              end
            else
              super(options_or_obj)
            end
          end
          
          def content
            @doc.content
          end
          
          def content=(value)
            @doc.content = value
          end
          
          def uri
            @doc["uri"]
          end
          
          def uri=(value)
            @doc["uri"] = value
          end
      
          def version
            @doc["version"]
          end
          
          def version=(value)
            @doc["version"] = value
          end
        end
      end
    end
  end
end
