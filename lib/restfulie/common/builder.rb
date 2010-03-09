#initialize namespace
module Restfulie::Builder; end

%w(
  base
  helpers
  marshalling
  rules/base
  rules/link
  rules/links
  rules/namespace
  rules/member_rules
  rules/collection_rules
).each do |file|
  require File.join(File.dirname(__FILE__), 'builder', file)
end