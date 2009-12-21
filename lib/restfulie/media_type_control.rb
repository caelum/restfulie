module Restfulie
  
  module MediaTypeControl
    
    # defines a custom media_type for this type
    def media_type(*args)
      args.each do |name|
        custom_representations << name
        type = Restfulie::MediaType.rendering_type(name, self)
        Restfulie::MediaType.register(type)
      end
    end
    
    # returns the list of media types available for this resource to be deserialized from
    def media_types
      Restfulie::MediaType.default_types + MediaType.medias_for(self)
    end
    
    # returns a list of media types that this resource can be serialized to
    def media_type_representations
      custom_representations + Restfulie::MediaType.default_representations.dup
    end
    
    private
    
    # this model's custom representations. those representations were added through media_type definitions
    def custom_representations
      @custom_representations ||= []
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
    
      # TODO move to MediaTypeControl.custom_media_types
      def medias_for(type)
        found = {}
        type.media_type_representations.each do |key|
          found[key] = media_types[key]
        end
        found.values
      end
      
    end
    
  end
  
end
