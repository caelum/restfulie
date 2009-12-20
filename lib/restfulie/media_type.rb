require 'restfulie/media_type_control'

module Restfulie
  
  # TODO rename it and move it
  def self.default_types
    [CustomType.new('html', self, lambda {}),
      rendering_type('application/xml', self),
      rendering_type('application/json', self),
      rendering_type('xml', self),
      rendering_type('json', self)]
  end
  
  # TODO remove this nasty method
  def self.rendering_type(name, type)
    Type.new(name,type)
  end
  
  # TODO remove this method
  def self.custom_type(name, type, l)
    CustomType.new(name, type, l)
  end
  
  class Type
    attr_reader :name, :type
    def initialize(name, type)
      @name = name
      @type = type
    end
    def short_name
      name.gsub(/\//,'_').gsub(/\+/,'_').gsub(/\./,'_')
    end
    
    def format_name
      name[/(.*[\+\/])?(.*)/,2]
    end
    def execute_for(controller, resource, options, render_options)
      formatted_resource = ["xml", "json"].include?(format_name) ? resource.send(:"to_#{format_name}", options) : resource
      render_options[:text] = formatted_resource
      render_options[:content_type] = name
      controller.render render_options
    end
  end
  
  class CustomType < Type
    def initialize(name, type, l)
      super(name, type)
      @lambda = l
    end
    def execute_for(controller, resource, options, render_options)
      @lambda.call
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
  
  Restfulie::MediaType.register(rendering_type('text/html', DefaultMediaTypes))
  Restfulie::MediaType.register(rendering_type('application/xml', DefaultMediaTypes))
  Restfulie::MediaType.register(rendering_type('application/json', DefaultMediaTypes))
  Restfulie::MediaType.register(rendering_type('xml', DefaultMediaTypes))
  Restfulie::MediaType.register(rendering_type('json', DefaultMediaTypes))
  
  
end

def safe_json_decode(json)
  return {} if !json
  begin
    ActiveSupport::JSON.decode json
  rescue ; {} end
end
