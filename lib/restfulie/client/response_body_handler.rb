%w(
  base
  atom_body_handler
).each do |file|
  require "restfulie/client/response_body_handlers/#{file}"
end

