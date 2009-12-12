module Restfulie
  module MediaTypeControl
    def media_type(*args)
      args.each do |name|
        Restfulie::MediaType.register(name, self)
      end
    end
  end
  
  module MediaType
    def self.register(name, who)
      media_types[name] = who
    end
    def self.media_type(name)
      raise UnsupportedContentType.new("unsupported content type '#{name}'") if media_types[name].nil?
      media_types[name]
    end
    private
    def self.media_types
      @media_types ||= {}
    end
  end
  
  # deserializes data from a request body.
  # uses the request 'Content-type' header to look for the corresponding media type.
  # To register a media type use:
  # class City
  #  uses_restfulie
  #  media_type 'vnd/caelum_city+xml'
  # end
  def self.from(request)
    media_class = MediaType.media_type(request.headers['CONTENT_TYPE'])
    media_class.from_xml(request.body.string)
  end
  
end