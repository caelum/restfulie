module Restfulie
  module Common
    module Converter
      module Xml
        module Helpers
          def collection(obj, *args, &block)
            Xml.to_xml(obj, {}, &block)
          end
        
          def member(obj, *args, &block)
            Xml.to_xml(obj, {}, &block)
          end
        end
      end
    end
  end
end
