module Restfulie
  module Common
    module Converter
      module Xml
        
        # an object to represent a list of links that can be invoked
        class Links < Hash
          
          def initialize(links)
            super()
            links = [links] unless links.kind_of? Array
            links = [] unless links
            links.each { |l|
              link = Restfulie::Common::Converter::Xml::Link.new(l)
              self[link.rel.to_s] = link
            }
          end
          
          def method_missing(sym, *args)
            self[sym.to_s]
          end
        end
      end
    end
  end
end
