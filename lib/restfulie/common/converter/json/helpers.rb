module Restfulie
  module Common
    module Converter
      module Json
        module Helpers
          def collection(obj, *args, &block)
            Restfulie::Common::Converter::Json.to_json(obj, &block)
          end
        
          def member(obj, *args, &block)
            Restfulie::Common::Converter::Json.to_json(obj, &block)
          end
        end
      end
    end
  end
end
