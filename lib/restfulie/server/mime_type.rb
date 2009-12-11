module Restfulie
  module MimeTypeControl
    def media_type(*args)
      args.each do |name|
        puts "#{name}"
        Restfulie::MimeType.register(name, self)
      end
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