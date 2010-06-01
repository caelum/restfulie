module Restfulie
  module Common
    module Representation
      module Atom
        class Source < XML    
          def initialize(options_or_obj)
            if options_or_obj.kind_of?(Hash)
              @doc = Nokogiri::XML::Document.new()
              node = @doc.create_element("source")
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
          
          def id
            text("id")
          end
      
          def id=(value)
            set_text("id", value)
          end
      
          # text
          def title
            text("title")
          end
        
          def title=(value)
            set_text("title", value)
          end
      
          def updated
            value = text("updated")
            Time.parse(value) unless value.nil?
          end
        
          def updated=(value)
            set_text("updated", value)
          end
      
          # text
          def rights
            text("rights")
          end
      
          def rights=(value)
            set_text("rights", value)
          end
        end
      end
    end
  end
end
