module Restfulie
  
  module Transitions

    class Transition
      attr_reader :body, :name, :result
      def initialize(name, options, result, body)
        @name = name
        @options = options
        @result = result
        @body = body
      end
      def action
        @options
      end
      def execute_at(target_object)
        target_object.status = result.to_s unless result.nil?
      end
    end
  
  end
  
end