%w(
  action_controller
  action_view 
).each do |file|
  require "restfulie/server/action_pack/#{file}"
end

