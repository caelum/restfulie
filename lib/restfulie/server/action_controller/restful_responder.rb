module Restfulie
  module Server
    module ActionController
      class RestfulResponder < ::ActionController::Responder
        
        include CacheableResponder
        include CreatedResponder

      end
    end
  end
end
