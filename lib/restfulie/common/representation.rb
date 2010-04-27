#initialize namespace
module Restfulie::Common::Representation; end

%w(
  atom
  generic
  json
  xml
).each do |file|
  require File.join(File.dirname(__FILE__), 'representation', file)
end

