module Restfulie::Server::HTTP
end

%w(
  base
  xml_unmarshal
).each do |file|
  require "restfulie/server/unmarshal/#{file}"
end
