module Restfulie::Client::HTTP#:nodoc:
end

%w(
  error
  adapter
  cache
  marshal
  atom_ext
  xml_ext
).each do |file|
  require "restfulie/client/http/#{file}"
end

