module Restfulie
  module Client#:nodoc
    module Base
      include HTTP::RequestMarshaller
     
      def self.included(base)#:nodoc
        base.extend(self)
      end
  
      def uses_restfulie(configuration = Configuration.new,&block)
        EntryPoint.configuration_for(resource_name,configuration,&block)
        configure
      end
  
      def configure
        configuration = EntryPoint.configuration_of(resource_name)
        raise "Undefined configuration for #{resource_name}" unless configuration
        at(configuration.entry_point)
        configuration.representations.each do |representation_name,representation|
          register_representation(representation_name,representation)
        end
      end
  
      def resource_name
        @resource_name ||= self.class.to_s.to_sym 
      end
    end
  end
end
