require 'rubygems'
require 'restfulie'

class Maze::Enter
  def execute(maze)
    maze.item.start.get
  end
end

class Maze::Move
  def initialize(direction)
    @direction = direction
  end
  def execute(room)
    room.cell.send(@direction).get
  end
end

class Maze::Pick
  def execute(mazes)
    mazes.maze.get
  end
end

class Maze::Back
  def initialize(path)
    @path = path
  end
  def execute(actual)
    return nil if @path.empty?
    last = @path.delete_at(@path.length-1)
    Restfulie.at(last).get
  end
end

class Maze::BackTracObjective
  
  def initialize
    @path = []
    @visited = []
  end

  def next_step(resource)
    next_step2(resource) || Maze::Back.new(@path)
  end
  
  def visited?(uri)
    @visited.include?(uri)
  end

end

class Maze::ExitBackTracking < Maze::BackTracObjective
  
  def completed?(resource)
    resource.respond_to?(:cell) && resource.cell.links(:exit)
  end
  
  def next_step2(resource)
    direction = [:east, :west, :north, :south].find do |direction|
      resource.respond_to?(:cell) && resource.cell.links(direction) && !visited?(resource.cell.links(direction).href)
    end
    if direction
      @path << resource.cell.links(direction).href
      @visited << resource.cell.links(direction).href
      Maze::Move.new(direction) 
    elsif resource.respond_to?(:item) && resource.item.links(:start)
      Maze::Enter.new
    elsif resource.respond_to?(:maze)
      Maze::Pick.new 
    else
      nil
    end
  end
  
end

# def scenarios
#   
#   When can go east
#   Then take east
#   
#   When can go north
#   Then take north
#   
#   When can go west
#   Then take west
#   
#   When can go south
#   Then take south
#   
#   # what about some random stuff?
#   
#   When there is a maze
#   Then enter it
#   
#   When there are mazes
#   Then pick a random one
# 
# end





context Maze do
  Mikyung.new(Maze::ExitBackTracking.new, Restfulie.at('http://amundsen.com/examples/mazes/2d/five-by-five/').accepts('application/vnd.amundsen.maze+xml').get! ).run
end
