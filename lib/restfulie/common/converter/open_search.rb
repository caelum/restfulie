module Restfulie
  module Common
    class Converter::OpenSearch#:nodoc:
      autoload :Descriptor, 'restfulie/common/converter/open_search/descriptor'
    end
  end
end

class Restfulie::Common::Converter::OpenSearch
  
  def self.unmarshal(xml)
    hash = Hash.from_xml(xml)
    descriptor = Descriptor.new(hash)
  end
  
end
