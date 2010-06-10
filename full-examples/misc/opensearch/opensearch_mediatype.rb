class OpenSearchEngine
  
  def initialize(uri)
    @description = Restfulie.accepts("application/opensearchdescription+xml").at(uri).get!
  end
  
  def get!(content)
    post!(content)
  end
  
  def post!(terms)
    urls = @description["OpenSearchDescription"]["Url"]
    uri = urls["template"].gsub("{searchTerms}", terms).gsub("{startPage?}","1")
    type = urls["type"]
    Restfulie.at(uri).accepts(type).get!
  end
  
  include Restfulie::Client::HTTP::RequestMarshaller
  
end


module Restfulie::Common::Representation

  class OpenSearch

    cattr_reader :media_type_name
    @@media_type_name = 'application/opensearchdescription+xml'

    cattr_reader :headers
    @@headers = { 
      :get  => { 'Accept'       => media_type_name },
      :post => { }
    }

    #Convert raw string to rAtom instances
    def unmarshal(content)
      Hash.from_xml(content)
    end

    def marshal(content)
      content
    end
    
    # prepares a link request element based on a relation.
    def prepare_link_for(link)
      if link.rel=="search"
        OpenSearchEngine.new(link.href)
      else
        link
      end
    end
    
  end

end

Restfulie::Client::HTTP::RequestMarshaller.register_representation("application/opensearchdescription+xml", Restfulie::Common::Representation::OpenSearch)
