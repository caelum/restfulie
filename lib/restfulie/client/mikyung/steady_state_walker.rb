# A steady walker that tries 3 times each step
module Restfulie
  module Client
    module Mikyung
      class SteadyStateWalker
        def move(goal, current, mikyung)
          step = goal.next_step(current, mikyung)
          raise UnableToAchieveGoalError, "No step was found for #{current}" unless step
          Common::Logger.logger.debug "Mikyung > next step will be #{step}"
          step = step.new if step.kind_of? Class
          try_to_execute(step, current, 3, mikyung)
        end
      
        private
        
          def try_to_execute(step, current, max_attempts, mikyung)
            raise "Unable to proceed when trying to #{step}" if max_attempts == 0
        
            resource = step
            raise "Step returned 'give up'" if resource.nil?
        
            if step.respond_to?(:execute)
              resource = step.execute(current, mikyung)
            end
        
            unless resource.response.code == 200
              try_to_execute(step, current, max_attempts-1, mikyung)
            else
              Common::Logger.logger.debug resource.response.body
              resource
            end
          end
      end
    end
  end
end
