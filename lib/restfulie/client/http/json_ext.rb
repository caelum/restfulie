module Restfulie
  module Common
    module Representation
      class Json
        class Link
          include Restfulie::Client::HTTP::LinkRequestBuilder
        end
      end
    end
  end
end
