module Restfulie
  module Common
    module Converter
      module Xml
        autoload :Base, 'restfulie/common/converter/xml/base'
        autoload :Builder, 'restfulie/common/converter/xml/builder'
        autoload :Helpers, 'restfulie/common/converter/xml/helpers'
        autoload :Links, 'restfulie/common/converter/xml/links'
        autoload :Link, 'restfulie/common/converter/xml/link'
        extend Base::ClassMethods
      end
    end
  end
end
