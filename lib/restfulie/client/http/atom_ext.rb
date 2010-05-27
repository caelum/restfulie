# inject new behavior in Atom instances to enable easily access to link relationships.
module Restfulie
  module Common
    module Representation
      module Atom
        class Link
          include Restfulie::Client::HTTP::LinkRequestBuilder
        end
      end
    end
  end
end
