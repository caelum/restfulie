module Restfulie
  module Client
    module Mikyung
      module Languages
        module Portuguese
          def Quando(concat, &block)
            When(concat, &block)
          end
          def E(concat, &block)
            And(concat, &block)
          end
          def Mas(concat, &block)
            But(concat, &block)
          end
          def Entao(concat, &block)
            Then(concat, &block)
          end
        end
      end
    end
  end
end

