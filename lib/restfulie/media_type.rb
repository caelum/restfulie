require 'restfulie/media_type_control'

module Restfulie
  
  module MediaType
    
    # TODO removethis nasty method
    def self.rendering_type(name, type)
      Restfulie::MediaType.media_types[name] || Type.new(name,type)
    end
  
    # TODO remove this method
    def self.custom_type(name, type, l)
      Restfulie::MediaType.media_types[name] || CustomType.new(name, type, l)
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
        response = ["xml", "json"].include?(format_name) ? resource.send(:"to_#{format_name}", options) : resource
        render(controller, response, render_options)
      end
      def render(controller, response, options)
        options[:text] = response
        options[:content_type] = name
        controller.render options
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
    
    module DefaultMediaTypeDecoder
    
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
  end
  
end

def safe_json_decode(json)
  return {} if !json
  begin
    ActiveSupport::JSON.decode json
  rescue ; {} end
end

require 'restfulie/media_type_defaults'
