module Restfulie
  module Common
    module Converter
      module Xml
        class Links
          def initialize(links)
            links = [links] unless links.kind_of? Array
            links = [] unless links
            @links = links.map do |l|
              link = Restfulie::Common::Converter::Xml::Link.new(l)
              link.instance_eval { self.class.send :include, ::Restfulie::Client::HTTP::LinkRequestBuilder }
              link
            end
          end
          
          def method_missing(sym, *args)
            @links.find do |link|
              link.rel == sym.to_s
            end
          end
        end
      end
    end
  end
end
