#initialize namespace
module Restfulie::Common::Converter; end

%w(
  atom
).each do |file|
  require File.join(File.dirname(__FILE__), 'converter', file)
end
