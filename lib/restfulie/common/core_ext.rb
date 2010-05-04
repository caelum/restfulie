%w(
  proc
).each do |file|
  require File.join(File.dirname(__FILE__), 'core_ext', file)
end
