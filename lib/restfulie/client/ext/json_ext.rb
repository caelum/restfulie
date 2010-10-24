# inject new behavior in Atom instances to enable easily access to link relationships.
module Restfulie
  module Common
    module Representation
      class Json
        class Link
          def follow
            r = Restfulie.at(href)
            r = r.as(type) if type
            r
          end
        end
      end
    end
  end
end
