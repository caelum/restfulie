module Restfulie
  module Common
    module Converter
      module Xml
        module Helpers
          def collection(obj, opts = {}, &block)
            Xml.to_xml(obj, opts, &block)
          end
        
          def member(obj, opts = {}, &block)
            Xml.to_xml(obj, opts, &block)
          end
        end
      end
    end
  end
end
