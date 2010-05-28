#initialize namespace
module Restfulie::Common::Converter; end

%w(
  values
  atom
  atom/builder
  atom/helpers
  json
  json/builder
  json/helpers
).each do |file|
  require File.join(File.dirname(__FILE__), 'converter', file)
end
