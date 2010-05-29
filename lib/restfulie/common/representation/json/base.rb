module Restfulie
  module Common
    module Representation
      class Json
        module Base
          module ClassMethods
            
            # creates a json unmarshalled version of this object
            def create(obj = nil)
              @json = {}
              return @json.extend(KeysAsMethods) unless obj
              
              if obj.kind_of?(Hash) || obj.kind_of?(Array)
                @json = obj
              else 
                @json = ::JSON.parse(obj)
              end
              
              @json.extend(KeysAsMethods)
            end
            
          end
        end
      end
    end
  end
end
