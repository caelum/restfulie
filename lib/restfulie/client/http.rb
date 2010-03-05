
module Restfulie::Client::HTTP; end

%w(
  error
  wrapper
  cache
  marshal
  marshals/atom
).each do |file|
  require "restfulie/client/http/#{file}"
end

