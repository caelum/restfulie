
module Restfulie
  module Client#:nodoc
    
    module HTTP::RecipeModule
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
    
    class HTTP::Recipe < MasterDelegator

      def initialize(requester)
        @requester = requester
        @resources_configurations = {}
      end
      
      include Restfulie::Client::HTTP::RecipeModule

    end
    
    class EntryPoint
      
      @resources_configurations = {}
      extend Restfulie::Client::HTTP::RecipeModule
      
      def initialize(requester)
        @requester = requester
      end

      def self.at(uri)
        Restfulie.using {
          recipe
          follow_link
          request_marshaller
          verb_request
        }.at(uri)
      end

    end
  end
end
