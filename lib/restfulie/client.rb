require 'restfulie/common'

module Restfulie
  module Client
    autoload :HTTP, 'restfulie/client/http'
    autoload :Configuration, 'restfulie/client/configuration'
    autoload :EntryPoint, 'restfulie/client/entry_point'
    autoload :Base, 'restfulie/client/base'
    autoload :Mikyung, 'restfulie/client/mikyung'
  end
end

require 'restfulie/client/ext/http_ext'
require 'restfulie/client/ext/atom_ext'
require 'restfulie/client/ext/json_ext'
require 'restfulie/client/ext/xml_ext'

