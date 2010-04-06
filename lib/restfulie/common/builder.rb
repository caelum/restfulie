#initialize namespace
module Restfulie::Common::Builder; end

%w(
  helpers
  base
  converter
  part/base
  part/link
  part/links
  part/namespace
  part/member
  part/collection
).each do |file|
  require File.join(File.dirname(__FILE__), 'builder', file)
end
