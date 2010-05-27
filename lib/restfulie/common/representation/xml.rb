module Restfulie
  module Common
    module Representation
      # Implements the interface for marshal Xml media type requests (application/xml)
      class XmlD
        cattr_reader :media_type_name
        @@media_type_name = 'application/xml'
    
        cattr_reader :headers
        @@headers = { 
          :post => { 'Content-Type' => media_type_name }
        }
    
        def unmarshal(string)
          Hash.from_xml(string)
        end
    
        def marshal(entity, rel)
          return entity if entity.kind_of? String
          return entity.values.first.to_xml(:root => entity.keys.first) if entity.kind_of?(Hash) && entity.size==1
          entity.to_xml
        end
      end
    end
  end
end
