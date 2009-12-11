module Restfulie
  module MimeTypeControl
    def media_type(name)
      Restfulie::MimeType.register(name, self)
    end
  end
  module MimeType
    def self.register(name, who)
      mime_types[name] = who
    end
    def self.mime_types
      @mime_types ||= {}
    end
  end
  def self.from(name)
    MimeType.mime_types[name]
  end
end