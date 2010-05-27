# Checks whether one or more rule holds and is capable of executing results.
module Restfulie
  module Client
    module Mikyung
      # Creates a conditional execution based on a description.
      # Its rule is an array where its first element represents a rule name and second a lambda that returns true or false
      # Its params are extra params that might be passed to the rule
      # Example
      # WhenCondition.new("when running", ["", lambda { |resource| resource.human.state=='running' }], "")
      class WhenCondition
        def initialize(description, rule, params)
          @description = description
          @results = []
          @extra = []
          @rule = rule
          @params = params
        end
      
        # will execute the first attached result
        def execute(resource, goal, mikyung)
          @results.each do |result|
            Restfulie::Common::Logger.logger.info("will '#{result.description}'")
            return result.execute(resource, goal, mikyung)
          end
        end
      
        # checks whether this step should execute for a specific resource
        def should_run_for(resource, goal)
          if @rule[1].arity == 2
            rule_accepts = @rule[1].call(resource, @params)
          else
            rule_accepts = @rule[1].call(resource)
          end
          return false unless rule_accepts
          !@extra.find do |condition|
            !condition.should_run_for(resource, goal)
          end
        end
      
        # adds an extra condition to this step
        def and(condition)
          @extra << condition
        end
        
        # adds an extra condition to this step
        def but(condition)
          @extra << condition
        end
        
        # adds an extra result to this step
        def results_on(result)
          @results << result
        end
      end
    end
  end
end
