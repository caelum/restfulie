require 'restfulie/media_type_control'

module Restfulie
  
  # TODO rename it and move it
  def self.default_types
    [Type.new('application/xml', self), Type.new('application/json', self), Type.new('xml', self), Type.new('json', self), CustomExecutionType.new('html', self, lambda {})]
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
  
  # TODO should be refactored: Type should be a type that receives a block, serializing type should contain serialization
  class CustomExecutionType < Type
    attr_reader :name, :type
    def initialize(name, type, lambda)
      @name = name
      @type = type
      @lambda = lambda
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
  
  Restfulie::MediaType.register(Type.new('application/xml', DefaultMediaTypes))
  Restfulie::MediaType.register(Type.new('application/json', DefaultMediaTypes))
  Restfulie::MediaType.register(Type.new('xml', DefaultMediaTypes))
  Restfulie::MediaType.register(Type.new('json', DefaultMediaTypes))
  
  
end

def safe_json_decode(json)
  return {} if !json
  begin
    ActiveSupport::JSON.decode json
  rescue ; {} end
end
