module Restfulie
  
  module MediaType
    def self.HtmlType
      Restfulie::MediaType.custom_type('html', self, lambda {})
    end
    def self.TextHtmlType
      Restfulie::MediaType.custom_type('text/html', self, lambda {})
    end
  
    # TODO rename it and move it
    def self.default_types
      [Restfulie::MediaType.HtmlType,
        Restfulie::MediaType.TextHtmlType,
        Restfulie::MediaType.rendering_type('application/xml', self),
        Restfulie::MediaType.rendering_type('application/json', self),
        Restfulie::MediaType.rendering_type('xml', self),
        Restfulie::MediaType.rendering_type('json', self)]
    end

    # TODO should allow aliases...
    Restfulie::MediaType.register(Restfulie::MediaType.HtmlType)
    Restfulie::MediaType.register(Restfulie::MediaType.TextHtmlType)
    Restfulie::MediaType.register(rendering_type('application/xml', DefaultMediaTypeDecoder))
    Restfulie::MediaType.register(rendering_type('application/json', DefaultMediaTypeDecoder))
    Restfulie::MediaType.register(rendering_type('xml', DefaultMediaTypeDecoder))
    Restfulie::MediaType.register(rendering_type('json', DefaultMediaTypeDecoder))
  end
end
