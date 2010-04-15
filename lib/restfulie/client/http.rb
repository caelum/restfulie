module Restfulie::Client::HTTP#:nodoc:
end

%w(
  error
  adapter
  cache
  marshal
  link
  atom_ext
  xml
).each do |file|
  require "restfulie/client/http/#{file}"
end

