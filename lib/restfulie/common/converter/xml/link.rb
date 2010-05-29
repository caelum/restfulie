module Restfulie
  module Common
    module Converter
      module Xml
        class Link
          def initialize(options = {})
            @options = options
          end
          def href
            @options["href"]
          end
          def rel
            @options["rel"]
          end
          def content_type
            @options["type"]
          end
          def type
            content_type
          end
        end
      end
    end
  end
end
