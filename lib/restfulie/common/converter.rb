module Restfulie
  module Common
    
    # Restfulie supports by default a series of media formats, such as
    # xml, json, atom, opensearch and form-urlencoded.
    # Use register to register your own media format, but
    # do not forget to contribute with your converter if
    # it is a well known media type that Restfulie still
    # does not support.
    module Converter
      Dir["#{File.dirname(__FILE__)}/converter/*.rb"].each {|f| autoload File.basename(f)[0..-4].camelize.to_sym, f }

      def self.register(media_type,representation)
        representations[media_type] = representation
      end

      def self.content_type_for(media_type)
        return nil if media_type.nil?
        content_type = media_type.split(';')[0] # [/(.*?);/, 1]
        representations[content_type]
      end
      
      # extracts the first converter that works for any of the acceptable media types
    	def self.find_for(accepts = [])
  			accepts.find do |accept|
  			  content_type_for(accepts[0])
  		  end
  	  end
  	  
      private
      
      def self.representations
        @representations ||= {}
      end
      
      register 'application/atom+xml' , ::Tokamak::Atom
      register 'application/xml' , ::Tokamak::Xml
      register 'text/xml' , ::Tokamak::Xml
      register 'application/json' , ::Tokamak::Json
      register 'application/opensearchdescription+xml' , ::Restfulie::Common::Converter::OpenSearch
      register 'application/x-www-form-urlencoded', Restfulie::Common::Converter::FormUrlEncoded
      
    end
  end
end

