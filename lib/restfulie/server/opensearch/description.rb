module Restfulie
  module OpenSearch
    
    class Description
      
      def self.define(attribute, xml_attribute)
        
        define_method("#{attribute.to_s}=") do |new_value|
          self.instance_variable_set(xml_attribute, new_value)
        end
        
        define_method(attribute.to_s) do |new_value|
          self.instance_variable_get xml_attribute
        end
        
      end
      
      define(:short_name, :@ShortName)
      define(:description, :@Description)
      define(:tags, :@Tags)
      define(:contact, :@Contact)
      
      def initialize(name)
        short_name = name
        description = name
        @types = []
      end
      
      def accepts(content_type)
        @types << content_type
        self
      end
      
    end
    
  end
end