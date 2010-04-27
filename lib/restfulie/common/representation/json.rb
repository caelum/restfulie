module Restfulie::Common::Representation

  # Implements the interface for marshal Xml media type requests (application/xml)
  class Json

    cattr_reader :media_type_name
    @@media_type_name = 'application/json'

    cattr_reader :headers
    @@headers = { 
      :post => { 'Content-Type' => media_type_name }
    }

    def unmarshal(string)
      raise Restfulie::Common::Error::RestfulieError, "Json deserialization not yet implemented"
    end

    def marshal(string, rel)
      string
    end

  end

end
