module Restfulie::Common::Representation
  # Implements the interface for marshal Xml media type requests (application/xml)
  class XmlD

    cattr_reader :media_type_name
    @@media_type_name = 'application/xml'

    cattr_reader :headers
    @@headers = { 
      :post => { 'Content-Type' => media_type_name }
    }

    def unmarshal(string)
      raise "should never be invoked, xml to ruby objects should be handled by rails itself"
    end

    def marshal(string, rel)
      string
    end

  end

end

