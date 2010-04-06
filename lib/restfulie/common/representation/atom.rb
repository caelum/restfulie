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

    #Convert raw string to rAtom instances
    def unmarshal(content)
      ::Atom::Feed.load_feed(content)
    end

    def marshal(string)
      string
    end

    def self.to_hash(string)
      Hash.from_xml(string).with_indifferent_access
    end
  end

end

