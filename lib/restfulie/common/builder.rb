#initialize namespace
module Restfulie::Builder; end

%w(
  base
  helpers
  rules
  entry_rules
  collections_rules
  marshalling
).each do |file|
  require File.join(File.dirname(__FILE__), 'builder', file)
end