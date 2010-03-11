#initialize namespace
module Restfulie::Builder; end

%w(
  helpers
  base
  marshalling
  rules/base
  rules/link
  rules/links
  rules/namespace
  rules/member_rule
  rules/collection_rule
).each do |file|
  require File.join(File.dirname(__FILE__), 'builder', file)
end