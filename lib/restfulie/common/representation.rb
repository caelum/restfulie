#initialize namespace
module Restfulie
  module Common
    module Representation
      autoload :Atom, 'restfulie/common/representation/atom'
      autoload :Generic, 'restfulie/common/representation/generic'
      autoload :XmlD, 'restfulie/common/representation/xml'
    end
  end
end

require 'restfulie/common/representation/json'
