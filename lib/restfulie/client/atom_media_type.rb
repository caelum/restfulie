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
        hash = entry[position].content.hash
        hash = hash.dup
        hash.delete("type")
        result = Restfulie::MediaType::DefaultMediaTypeDecoder.from_hash(hash)
        if entry[position].respond_to?(:link)
          transitions = entry[position].link.hash
          transitions = [transitions] if transitions.kind_of? Hash
          result.add_transitions(transitions)
        end
      end
      
    end
    
  end
  
  Restfulie::MediaType.register(Restfulie::MediaType.rendering_type('application/atom+xml', Server::AtomMediaType))
  
end
