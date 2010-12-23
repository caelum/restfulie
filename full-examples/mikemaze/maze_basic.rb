require 'rubygems'
require 'restfulie'

Restfulie::Common::Logger.logger.level = Logger::INFO

current = Restfulie.at('http://amundsen.com/examples/mazes/2d/five-by-five/').accepts("application/xml").get.headers

steps = 0

visited = {}
path = []

while(!current.link("exit"))  do
  
  puts "available links are #{current.links.keys}"
  puts current.links
  
  link = ["start", "east", "west", "south", "north"].find do |direction|    # puts "#{direction} #{!visited[current.link(direction).href]}"
    current.link(direction) && !visited[current.link(direction).href]
  end
  
  if !link
    path.pop
    link = path.pop
  else
    link = current.link(link)
  end

  visited[link.href] = true
  path << link
  current = link.follow.get.headers
  
  steps = steps + 1
  
end

puts "solved in #{steps} steps"
