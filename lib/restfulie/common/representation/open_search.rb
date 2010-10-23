module Restfulie
  module Common
    class Representation::OpenSearch#:nodoc:
      autoload :Descriptor, 'restfulie/common/representation/open_search/descriptor'
    end
  end
end

class Restfulie::Common::Representation::OpenSearch
  
  def unmarshal(xml)
    hash = Hash.from_xml(xml)
    descriptor = Descriptor.new(hash)
  end
  
end
