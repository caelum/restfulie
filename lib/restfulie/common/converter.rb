#initialize namespace
module Restfulie
  module Common
    module Converter
      autoload :Values, 'restfulie/common/converter/values'
      autoload :Atom, 'restfulie/common/converter/atom'
      autoload :Xml, 'restfulie/common/converter/xml'
      autoload :Builder, 'restfulie/common/converter/atom/builder'
      autoload :Helpers, 'restfulie/common/converter/atom/helpers'
    end
  end
end

