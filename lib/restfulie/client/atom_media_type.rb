module Restfulie
  
  # TODO break media type registering for DECODING and ENCODING appart, so we can have two files
  module Server
    
    # a decoder from atom an feed
    class AtomMediaType < Restfulie::MediaType::Type
      
      def self.from_xml(xml)
        hash = Hash.from_xml xml
        AtomFeedDecoded.new(hash.values.first)
      end
      
    end
    
    # an atom feed
    class AtomFeedDecoded < Hashi::CustomHash
      
      def initialize(hash)
        super(hash)
      end
  
      # retrieves the nth element from an atom feed
      def [](position)
        
        hash = entry[position].content.internal_hash
        hash = hash.dup
        hash.delete("type")
        result = Restfulie::MediaType::DefaultMediaTypeDecoder.from_hash(hash)
        
        add_links_to(result, entry[position]) if entry[position].respond_to?(:link)
        result
        
      end
      
      private
      
      def add_links_to(result, entry)
        links = entry.link.internal_hash
        links = [links] if links.kind_of? Hash
        self_definition = self_from(links)
        links << {:rel => "destroy", :method => "delete", :href => self_definition["href"]} unless self_definition.nil?
        result.add_transitions(links)
      end
      
      def self_from(links)
        links.find do |link|
          link["rel"] == "self" || link[:rel] == "self"
        end
      end
      
    end
    
  end
  
  Restfulie::MediaType.register(Restfulie::MediaType.rendering_type('application/atom+xml', Server::AtomMediaType))
  
end
