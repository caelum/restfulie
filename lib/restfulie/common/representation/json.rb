module Restfulie
  module Common
    module Representation
      # Implements the interface for marshal Xml media type requests (application/xml)
      class Json
        cattr_reader :media_type_name
        @@media_type_name = 'application/json'
    
        cattr_reader :headers
        @@headers = { 
          :post => { 'Content-Type' => media_type_name }
        }
    
        def unmarshal(string)
          JSON.parse(string)
        end
    
        def marshal(entity, rel)
          return entity if entity.kind_of? String
          entity.to_json
        end
      end
    end
  end
end
