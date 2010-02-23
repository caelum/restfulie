
module Restfulie::Client::HTTP; end

%w(
  error
  wrapper
  extensions
).each do |file|
  require "restfulie/client/http/#{file}"
end

