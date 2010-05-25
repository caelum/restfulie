%w(
  http
).each do |file|
  require "restfulie/client/http/core_ext/#{file}"
end

