module Restfulie
  module Client#:nodoc
    module EntryPoint
      include HTTP::RequestMarshaller
      include HTTP::RequestFollow
      extend self

      def self.at(uri)
        Object.new.send(:extend, EntryPoint).at(uri)
      end

      def recipe(converter_sym, options={}, &block)
        raise 'Undefined block' unless block_given?
        converter = "Restfulie::Common::Converter::#{converter_sym.to_s.camelize}".constantize
        converter.describe_recipe(options[:name], &block) 
      end

      @resources_configurations = {}
      def configuration_of(resource_name)
        @resources_configurations[resource_name]
      end

      def configuration_for(resource_name,configuration = Configuration.new)
        yield configuration if block_given?
        @resources_configurations[resource_name] = configuration
      end

      def retrieve(resource_name)
        returning Object.new do |resource| 
          resource.extend(Base)
          resource.configure
        end
      end
    end
  end
end
