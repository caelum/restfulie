module Restfulie
  module Server
    module ActionController
      class RestfulResponder < ::ActionController::Responder
        
        include Trait::Cacheable
        include Trait::Created

      end
    end
  end
end
