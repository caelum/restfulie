module Restfulie
  
  module MediaTypeControl
    
    def media_type(*args)
      args.each do |name|
        type = Restfulie::MediaType.rendering_type(name, self)
        Restfulie::MediaType.register(type)
      end
    end
    
    # returns the list of media types available for this resource
    def media_types
      Restfulie::MediaType.default_types + MediaType.medias_for(self)
    end
    
  end
  

  module MediaType
    
    class << self
    
      def register(type)
        Mime::Type.register(type.name, type.short_name.to_sym)
        media_types[type.name] = type
      end
    
      # TODO rename to type for mt
      def media_type(name)
        name = normalize(name)
        raise Restfulie::UnsupportedContentType.new("unsupported content type '#{name}'") if media_types[name].nil?
        media_types[name].type
      end
    
      def supports?(name)
        name = normalize(name)
        !media_types[name].nil?
      end
    
      def normalize(name)
        name[/[^;]*/]
      end
    
      def media_types
        @media_types ||= {}
      end
    
      def medias_for(type)
        media_types.dup.delete_if {|key, value| value.type!=type}.values
      end
      
    end
    
  end
  
  # deserializes data from a request body.
  # uses the request 'Content-type' header to look for the corresponding media type.
  # To register a media type use:
  # class City
  #  uses_restfulie
  #  media_type 'application/vnd.caelum_city+xml'
  # end
  def self.from(request)
    media_class = MediaType.media_type(request.headers['CONTENT_TYPE'])
    media_class.from_xml(request.body.string)
  end
  
end
