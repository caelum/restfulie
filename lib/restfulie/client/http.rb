module Restfulie::Client::HTTP; end

%w(
  error
  adapter
  cache
  marshal
  marshals/atom
).each do |file|
  require "restfulie/client/http/#{file}"
end

