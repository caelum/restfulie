module Restfulie
  module Common
    module Converter
      module Atom
        autoload :Base, 'restfulie/common/converter/atom/base'
        autoload :Builder, 'restfulie/common/converter/atom/builder'
        autoload :Helpers, 'restfulie/common/converter/atom/helpers'
        extend Base::ClassMethods
      end
    end
  end
end
