module Restfulie
  module Common
    module Converter
      module Json
        autoload :Base, 'restfulie/common/converter/json/base'
        autoload :Builder, 'restfulie/common/converter/json/builder'
        autoload :Helpers, 'restfulie/common/converter/json/helpers'
        extend Base::ClassMethods
      end
    end
  end
end
