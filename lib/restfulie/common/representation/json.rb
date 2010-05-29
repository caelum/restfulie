module Restfulie
  module Common
    module Representation
      class Json
        autoload :Base, 'restfulie/common/representation/json/base' 
        autoload :KeysAsMethods, 'restfulie/common/representation/json/keys_as_methods' 
        autoload :Link, 'restfulie/common/representation/json/link' 
        autoload :LinkCollection, 'restfulie/common/representation/json/link_collection' 
        extend Base::ClassMethods
      end
    end
  end
end
