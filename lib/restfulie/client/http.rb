
module Restfulie::Client::HTTP; end

%w(
  error
  wrapper
  cache
).each do |file|
  require "restfulie/client/http/#{file}"
end

