module Restfulie
  def self.HtmlType
    @HTML ||= CustomType.new('html', self, lambda {})
  end
  def self.TextHtmlType
    @TEXT_HTML ||= CustomType.new('text/html', self, lambda {})
  end
  
  # TODO rename it and move it
  def self.default_types
    [Restfulie.HtmlType,
      Restfulie.TextHtmlType,
      rendering_type('application/xml', self),
      rendering_type('application/json', self),
      rendering_type('xml', self),
      rendering_type('json', self)]
  end

  # TODO should allow aliases...
  Restfulie::MediaType.register(Restfulie.HtmlType)
  Restfulie::MediaType.register(Restfulie.TextHtmlType)
  Restfulie::MediaType.register(rendering_type('application/xml', DefaultMediaTypes))
  Restfulie::MediaType.register(rendering_type('application/json', DefaultMediaTypes))
  Restfulie::MediaType.register(rendering_type('xml', DefaultMediaTypes))
  Restfulie::MediaType.register(rendering_type('json', DefaultMediaTypes))
  
end
