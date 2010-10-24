# Atom links now can be followed
module Restfulie
  module Common
    module Representation
      module Atom
        class Link
          def follow
            Restfulie.at(href).as(type)
          end
        end
      end
    end
  end
end
