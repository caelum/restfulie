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
      mime_types[name] = who
    end
    def self.mime_types
      @mime_types ||= {}
    end
  end
  def self.from(name)
    MediaType.mime_types[name]
  end
end