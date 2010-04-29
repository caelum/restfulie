module Restfulie::Common::Representation
  # Implements the interface for unmarshal Atom media type responses (application/atom+xml) to ruby objects instantiated by rAtom library.
  #
  # Furthermore, this class extends rAtom behavior to enable client users to easily access link relationships.
  module Atom

    mattr_reader :media_type_name
    @@media_type_name = 'application/atom+xml'

    mattr_reader :headers
    @@headers = { 
      :get  => { 'Accept'       => media_type_name },
      :post => { 'Content-Type' => media_type_name }
    }

    def self.unmarshal(object, recipe_name = nil)
      Restfulie::Common::Converter::Atom.to_atom(object, recipe_name)
    end

    def self.marshal(object, recipe_name = nil)
      Restfulie::Common::Converter::Atom.to_atom(object, recipe_name).to_xml
    end

    def self.to_hash(object)
      Restfulie::Common::Converter::Atom.to_hash(object)
    end

  end

end

