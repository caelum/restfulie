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
  
  def self.from(request)
    media_class = MediaType.media_type(request['Content-type'])
    media_class.from_xml(request.body.string)
  end
  
end