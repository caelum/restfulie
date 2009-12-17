module Restfulie
  
  module MediaTypeControl
    
    def media_type(*args)
      args.each do |name|
        type = Restfulie::Type.new(name, self)
        Restfulie::MediaType.register(type)
      end
    end
    
    # returns the list of media types available for this resource
    def media_types
      [Type.new('application/xml', self), Type.new('application/json', self), Type.new('xml', self), Type.new('json', self)] + MediaType.medias_for(self)
    end
    
  end
  
  class Type
    attr_reader :name, :type
    def initialize(name, type)
      @name = name
      @type = type
    end
    
    def short_name
      name.gsub(/\//,'_').gsub(/\+/,'_')
    end
    
    def format_name
      name[/(.*[\+\/])?(.*)/,2]
    end
    
    # server side only (move it)
    def execute_for(controller, resource, options, render_options)
      formatted_resource = ["xml", "json"].include?(format_name) ? resource.send(:"to_#{format_name}", options) : resource
      render_options[:text] = formatted_resource
      render_options[:content_type] = name
      controller.render render_options
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
    
      def medias_for(type)
        media_types.dup.delete_if {|key, value| value.type!=type}.values
      end
      
    end
    
  end
  
  Restfulie::MediaType.register(Type.new('application/xml', DefaultMediaTypes))
  Restfulie::MediaType.register(Type.new('application/json', DefaultMediaTypes))
  Restfulie::MediaType.register(Type.new('xml', DefaultMediaTypes))
  Restfulie::MediaType.register(Type.new('json', DefaultMediaTypes))
  
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
