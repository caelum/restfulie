module Restfulie
  module Common
    module Representation
      module Atom
        class Category < XML    
          def initialize(options_or_obj)
            if options_or_obj.kind_of?(Hash)
              @doc = Nokogiri::XML::Document.new()
              options_or_obj = create_element("category", options_or_obj)
            end
            super(options_or_obj)
          end
          
          def term
            @doc["term"]
          end
          
          def term=(value)
            @doc["term"] = value
          end
          
          def scheme
            @doc["scheme"]
          end
          
          def scheme=(value)
            @doc["scheme"] = value
          end
      
          def label
            @doc["label"]
          end
          
          def label=(value)
            @doc["label"] = value
          end
        end
      end
    end
  end
end
