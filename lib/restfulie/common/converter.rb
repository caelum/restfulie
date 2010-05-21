#initialize namespace
module Restfulie::Common::Converter; end

%w(
  components
  atom
  atom/builder
  atom/helpers
).each do |file|
  require File.join(File.dirname(__FILE__), 'converter', file)
end
