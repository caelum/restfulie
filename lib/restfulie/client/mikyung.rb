module Restfulie::Client::Mikyung
end

%w(
  when_condition
  concatenator
  core
  steady_state_walker
  dsl
).each do |file|
  require "restfulie/client/mikyung/#{file}"
end

# Restfulie::Mikyung entry point is based on its core
# implementation.
class Restfulie::Mikyung < Restfulie::Client::Mikyung::Core
end
