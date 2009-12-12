module Restfulie
  
  module MediaTypeControl
    
    def media_type(*args)
      args.each do |name|
        Restfulie::MediaType.register(name, self)
      end
    end
    
  end
  
  module DefaultMediaTypes
    
    # from rails source code
    def self.constantize(camel_cased_word)
     unless /\A(?:::)?([A-Z]\w*(?:::[A-Z]\w*)*)\z/ =~ camel_cased_word
       raise NameError, "#{camel_cased_word.inspect} is not a valid constant name!"
     end

     Object.module_eval("::#{$1}", __FILE__, __LINE__)
    end
    
    def self.from_xml(xml)
      hash = Hash.from_xml xml
      raise "there should be only one root element" unless hash.keys.size==1

      head = hash[self.to_s.underscore]
      type = constantize(hash.keys.first.camelize) rescue Hashi
      
      result = type.from_hash hash.values.first
      return nil if result.nil?
      result._came_from = :xml if self.include?(Restfulie::Client::Instance)
      result
    end

    def self.from_json(json)
      hash = safe_json_decode(json)
      type = hash.keys.first.camelize.constantize
      type.from_hash(hash.values.first)
    end
    
  end
  
  module MediaType
    
    def self.register(name, who)
      media_types[name] = who
    end
    
    # TODO rename to type for mt
    def self.media_type(name)
      name = name[/[^;]*/]
      raise UnsupportedContentType.new("unsupported content type '#{name}'") if media_types[name].nil?
      media_types[name]
    end
    def self.media_types
      @media_types ||= {}
    end
  end
  
  Restfulie::MediaType.register('application/xml', DefaultMediaTypes)
  Restfulie::MediaType.register('application/json', DefaultMediaTypes)
  
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

def safe_json_decode(json)
  return {} if !json
  begin
    ActiveSupport::JSON.decode json
  rescue ; {} end
end
