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
          def follow
            r = Restfulie.at(href)
            r = r.as(content_type) if content_type
            r
          end
          
          def to_s
            "<link to #{@options}>"
          end
          
        end
      end
    end
  end
end
