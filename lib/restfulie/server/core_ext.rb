require 'restfulie/server/core_ext/array'

class Array
  include Restfulie::Server::CoreExtensions::Array
  extend Restfulie::MediaTypeControl
  media_type "application/atom+xml"
end