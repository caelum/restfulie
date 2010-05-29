module Restfulie
  module Common
    module Converter
      autoload :Values, 'restfulie/common/converter/values'
      autoload :Atom, 'restfulie/common/converter/atom'
      autoload :Json, 'restfulie/common/converter/json'
      autoload :Xml, 'restfulie/common/converter/xml'

      # Returns the default root element name for an item or collection
      def self.root_element_for(obj)
        if obj.kind_of?(Hash) && obj.size==1
          obj.keys.first.to_s
        elsif obj.kind_of?(Array) && !obj.empty?
          root_element_for(obj.first).underscore.pluralize
        else
          obj.class.to_s.underscore
        end
      end
    end
  end
end

