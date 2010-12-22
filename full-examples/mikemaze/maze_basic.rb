require 'rubygems'
require 'restfulie'
require 'ruby-debug'

Restfulie::Common::Logger.logger.level = Logger::DEBUG

map = Restfulie.at('http://amundsen.com/examples/mazes/2d/ten-by-ten/').accepts("application/xml").get

steps = 0

visited = []
path = []

while(!current.headers.link("exit")) do
  
  puts "available links are #{current.headers.links.keys}"
  
  link = ["start", "east", "west", "south", "north"].find do |direction|
    map.headers.link(direction) && !visited.contains[map.headers.link(direction).href]
  end
  
  if link
    visited << link.href
    path << link
    current = link.follow.get
  else
    current = path.pop
  end
  
  steps = steps + 1
  
end

puts "solved in #{steps} steps"
