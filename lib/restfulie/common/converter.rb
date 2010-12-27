module Restfulie
  module Common
    
    module Converter
      
      register 'application/atom+xml' , ::Restfulie::Common::Converter::Atom
      register 'application/xml' , ::Restfulie::Common::Converter::Xml
      register 'text/xml' , ::Restfulie::Common::Converter::Xml
      register 'application/opensearchdescription+xml' , ::Restfulie::Common::Converter::OpenSearch
      register 'application/x-www-form-urlencoded', Restfulie::Common::Converter::FormUrlEncoded
      
    end
  end
end

