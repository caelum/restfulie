%w(
  steady_state_walker
).each do |file|
  require "restfulie/client/mikyung/#{file}"
end

# iterates following a series of steps provided a goal and a starting uri.
#
# Restfulie::Client::Mikyung.achieve(objective).at(uri).run
#
# In order to implement your own walker, supply an object that respond to the move method.
# Check the run method code.
class Restfulie::Client::Mikyung
  
  attr_reader :start, :goal, :walker
  
  def initialize
    @walker = Restfulie::Client::SteadyStateWalker.new
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

  # keeps changing from a steady state to another until its goal has been achieved
  def run
    @start = current = (@start.kind_of? String) ? Restfulie.at(@start).get : @start
    
    while(!@goal.completed?(current))
      current = @walker.move(@goal, current, self)
    end
  end
  
end

class Mikyung < Restfulie::Client::Mikyung
end

class Restfulie::Client::UnableToAchieveGoalError < Restfulie::Common::Error::RestfulieError
end
