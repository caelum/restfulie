require 'rubygems'
require 'restfulie'

Restfulie::Common::Logger.logger.level = Logger::DEBUG

map = Restfulie.at('http://amundsen.com/examples/mazes/2d/ten-by-ten/').accepts("application/xml").get

current = map.headers.link("start").follow.get

steps = 0

while(!current.headers.link("exit")) do
  
  if current.headers.link("east")
    current = current.headers.link("east").follow.get
  elsif current.link("west")
    current = current.headers.link("west").follow.get
  elsif current.link("south")
    current = current.headers.link("south").follow.get
  elsif current.link("north")
    current = current.headers.link("north").follow.get
  end
  steps = steps + 1
  
end

puts "solved in #{steps} steps"
