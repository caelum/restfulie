module Restfulie
  module Client
    module Cache
      autoload :Basic, 'restfulie/client/cache/basic'
      autoload :Fake, 'restfulie/client/cache/fake'
      autoload :Restrictions, 'restfulie/client/cache/restrictions'
    end
  end
end
require 'restfulie/client/cache/http_ext'

