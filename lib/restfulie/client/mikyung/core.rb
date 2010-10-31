module Restfulie
  module Client
    module Mikyung
      # iterates following a series of steps provided a goal and a starting uri.
      #
      # Restfulie::Client::Mikyung.achieve(objective).at(uri).run
      #
      # In order to implement your own walker, supply an object that respond to the move method.
      # Check the run method code.
      class Core
        attr_reader :start, :goal, :walker, :accepts, :follow
        
        def initialize
          @walker = Restfulie::Client::Mikyung::SteadyStateWalker.new
        end
        
        def walks_with(walker)
          @walker = walker
          self
        end
      
        # initializes with a goal in mind
        def achieve(goal)
          @goal = goal
          self
        end
        
        def at(start)
          @start = start
          self
        end

        def follow
          @follow = true
          self
        end

        def accepts(accepts)
          @accepts = accepts
          self
        end
      
        # keeps changing from a steady state to another until its goal has been achieved
        def run

          # load the steps and scenario
          @goal.steps 
          @goal.scenario 

          if @start.kind_of? String
            client = Restfulie.at(@start)
            client = client.follow if @follow
            client = client.accepts(@accepts) if @accepts
            @start = current = client.get
          else
            # probably configured thru the Rest Process Model class
            @start = current = @goal.class.get_restfulie.get
          end
          
          while(!@goal.completed?(current))
            current = @walker.move(@goal, current, self)
          end
          current
        end
      end
    end

    class UnableToAchieveGoalError < Restfulie::Common::Error::RestfulieError
    end
  end
end
