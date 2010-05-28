#initialize namespace
module Restfulie::Common::Converter; end

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

%w(
  atom
  atom/builder
  atom/helpers
  json
  json/builder
  json/helpers
).each do |file|
  require File.join(File.dirname(__FILE__), 'converter', file)
end
