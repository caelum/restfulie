module Restfulie
  module Client
    module HTTP
      module LinkRequestBuilder
        include RequestMarshaller

        def path#:nodoc:
          at(href)
          as(type) if type
          super
        end
      end
    end
  end
end
