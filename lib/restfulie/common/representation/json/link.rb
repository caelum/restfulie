module Restfulie
  module Common
    module Representation
      class Json
        class Link
          def initialize(obj)
            @obj = obj
          end
          
          def type
            @obj.type
          end
          
          def href
            @obj.href
          end
          
          def rel
            @obj.rel
          end
              
          def method_missing(symbol, *args, &block)
            @obj.send(symbol, *args, &block)
          end
        end
      end
    end
  end
end
