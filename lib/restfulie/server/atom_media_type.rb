module Restfulie
  module Server
    module ArrayMediaType
    end
  end
end
class Array
  extend Restfulie::MediaTypeControl
  media_type "application/atom+xml"
end
