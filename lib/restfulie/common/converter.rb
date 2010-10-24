module Restfulie
  module Common
    module Converter
      Dir["#{File.dirname(__FILE__)}/converter/*.rb"].each {|f| autoload File.basename(f)[0..-4].camelize.to_sym, f }

      # Returns the default root element name for an item or collection
      def self.root_element_for(obj)
        if obj.kind_of?(Hash) && obj.size==1
          obj.keys.first.to_s
        elsif obj.kind_of?(Array) && !obj.empty?
          root_element_for(obj.first).to_s.underscore.pluralize
        else
          obj.class.to_s.underscore
        end
      end
    end
  end
end

