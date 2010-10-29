module Restfulie
  module Common
    module Converter
      Dir["#{File.dirname(__FILE__)}/converter/*.rb"].each {|f| autoload File.basename(f)[0..-4].camelize.to_sym, f }

      # Returns the default root element name for an item or collection
      def self.root_element_for(obj)
        if obj.kind_of?(Hash) && obj.size==1
          obj.keys.first.to_s
        elsif obj.kind_of?(Array) && !obj.empty?
          root_element_for(obj.first).to_s.underscore.pluralize
        else
          obj.class.to_s.underscore
        end
      end
      
      def self.register(media_type,representation)
        representations[media_type] = representation
      end

      def self.content_type_for(media_type)
        return nil unless media_type
        content_type = media_type.split(';')[0] # [/(.*?);/, 1]
        representations[content_type]
      end
      
      private
      
      def self.representations
        @representations ||= {}
      end
      
      register 'application/atom+xml' , ::Restfulie::Common::Converter::Atom
      register 'application/xml' , ::Restfulie::Common::Converter::Xml
      register 'text/xml' , ::Restfulie::Common::Converter::Xml
      register 'application/json' , ::Restfulie::Common::Converter::Json
      register 'application/opensearchdescription+xml' , ::Restfulie::Common::Converter::OpenSearch
      register 'application/x-www-form-urlencoded', Restfulie::Common::Converter::FormUrlEncoded
      
    end
  end
end

