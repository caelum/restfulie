module Restfulie
  module Common
    module Representation
      module Atom
        class Person < XML    
          def initialize(node_type, options_or_obj)
            if options_or_obj.kind_of?(Hash)
              @doc = Nokogiri::XML::Document.new()
              node = @doc.create_element(node_type)
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
          
          def name
            text("name")
          end
          
          def name=(value)
            set_text("name", value)
          end
          
          def uri
            text("uri")
          end
          
          def uri=(value)
            set_text("uri", value)
          end
      
          def email
            text("email")
          end
          
          def email=(value)
            set_text("email", value)
          end
        end
      end
    end
  end
end
