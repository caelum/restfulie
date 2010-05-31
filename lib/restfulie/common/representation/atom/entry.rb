module Restfulie
  module Common
    module Representation
      module Atom
        class Entry < Base   
          def initialize(xml_obj = nil)
            @source = nil
            super(xml_obj)
            @reserved = Base::ATOM_ATTRIBUTES[:entry][:required] + Base::ATOM_ATTRIBUTES[:entry][:recommended] + Base::ATOM_ATTRIBUTES[:entry][:optional]
          end
           
          # text
          def content
            text("content")
          end
      
          def content=(value)
            set_text("content", value)
          end
        
          # text
          def summary
            text("summary")
          end
      
          def summary=(value)
            set_text("summary", value)
          end
        
          # rfc 3339
          def published
            value = text("published")
            Time.parse(value) unless value.nil?
          end
      
          def published=(value)
            set_text("published", value)
          end
        
          # comp: id, title, udpated, rights (optional)
          def source
            unless @source
              @doc.xpath("xmlns:source").each do |source|
                @source = Generator.new(source)
              end 
            end
            
            return source
          end
          
          def source=(obj)
            @source = obj
          end
        end
      end
    end
  end
end

