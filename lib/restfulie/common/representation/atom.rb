require 'nokogiri'

module Restfulie
  module Common
    module Representation
      module Atom
        autoload :Factory, 'restfulie/common/representation/atom/factory'
        autoload :XML, 'restfulie/common/representation/atom/xml'
        autoload :Base, 'restfulie/common/representation/atom/base'
        autoload :TagCollection, 'restfulie/common/representation/atom/tag_collection'
        autoload :Link, 'restfulie/common/representation/atom/link'
        autoload :Person, 'restfulie/common/representation/atom/person'
        autoload :Category, 'restfulie/common/representation/atom/category'
        autoload :Feed, 'restfulie/common/representation/atom/feed'
        autoload :Entry, 'restfulie/common/representation/atom/entry'
      end
    end
  end
end
