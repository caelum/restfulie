module Restfulie
  module Client
    class StackNavigator
  
      def initialize(stack)
        @stack = stack.dup
      end

      def continue(request, env)
        current = @stack.pop
        if current.nil?
          return nil
        end
        filter = instantiator.new(current[:type], current[:args])
        Restfulie::Common::Logger.logger.debug "invoking filter #{filter.class.name} with #{request} at #{env}"
        filter.execute(self.dup, request, env)
      end
  
      def instantiator
        BasicInstantiator.new
      end
    
      def dup
        StackNavigator.new(@stack)
      end
  
    end

    class BasicInstantiator
      def new(type, args)
        if type.instance_method(:initialize).arity==1
          type.new(args)
        else
          type.new
        end
      end
    end
  end
end
