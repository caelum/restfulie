module Restfulie
  
  module MediaType
    def self.HtmlType
      custom_type('html', self, lambda {})
    end
    def self.TextHtmlType
      custom_type('text/html', self, lambda {})
    end
  
    # TODO rename it and move it
    def self.default_types
      [Restfulie::MediaType.HtmlType,
        Restfulie::MediaType.TextHtmlType,
        rendering_type('application/xml', self),
        rendering_type('application/json', self),
        rendering_type('xml', self),
        rendering_type('json', self)]
    end

    # TODO should allow aliases...
    register(Restfulie::MediaType.HtmlType)
    register(Restfulie::MediaType.TextHtmlType)
    register(rendering_type('application/xml', DefaultMediaTypeDecoder))
    register(rendering_type('application/json', DefaultMediaTypeDecoder))
    register(rendering_type('xml', DefaultMediaTypeDecoder))
    register(rendering_type('json', DefaultMediaTypeDecoder))
  end
end
