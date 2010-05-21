module Restfulie::Client::Mikyung
end

%w(
  when_condition
  then_condition
  rest_process_model
  concatenator
  core
  steady_state_walker
  languages
).each do |file|
  require "restfulie/client/mikyung/#{file}"
end

# Restfulie::Mikyung entry point is based on its core
# implementation.
class Restfulie::Mikyung < Restfulie::Client::Mikyung::Core
end
