module Restfulie::Common::Representation
  # Implements the interface for unmarshal Atom media type responses (application/atom+xml) to ruby objects instantiated by rAtom library.
  #
  # Furthermore, this class extends rAtom behavior to enable client users to easily access link relationships.
  class Atom

    cattr_reader :media_type_name
    @@media_type_name = 'application/atom+xml'

    cattr_reader :headers
    @@headers = { 
      :get  => { 'Accept'       => media_type_name },
      :post => { 'Content-Type' => media_type_name }
    }

    def unmarshal(object)
      object.extend(Restfulie::Common::Converter::Atom)
      object.to_atom
    end

    def marshal(object)
      object.extend(Restfulie::Common::Converter::Atom)
      object.to_atom.to_xml
    end

    def self.to_hash(object)
      object.extend(Restfulie::Common::Converter::Atom)
      object.to_atom.to_hash
    end

  end

end

