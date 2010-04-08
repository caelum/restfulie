module Restfulie::Common::Representation
  # Unknown representation's unmarshalling on the client side
  class Generic

    def self.media_type_name
      raise Restfulie::Common::Error::RestfulieError.new("Generic representation does not have a specific media type")
    end

    cattr_reader :headers
    @@headers = { 
      :get  => { },
      :post => { }
    }

    # Because there is no media type registered, return the content itself
    def unmarshal(content)
      def content.links
        []
      end
      content
    end

    def marshal(string)
      string
    end

    def prepare_link_for(link)
      link
    end
  end

end

