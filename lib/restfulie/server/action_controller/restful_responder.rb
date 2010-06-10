class Expires
  def do_http_cache(responder)
    if responder.options[:expires_in]
      responder.controller.send :expires_in,responder.options[:expires_in]
      true
    else
      false
    end
  end
end

class LastModifieds
  # default implementation that will check whether caching can be applied
  def do_http_cache?(responder)
    responder.resources.flatten.select do |resource|
      resource.respond_to?(:updated_at)
    end &&
      responder.controller.response.last_modified.nil? &&
      !new_record?(responder)
  end

    def do_http_cache(responder)
      return false unless do_http_cache?(responder)
      
      timestamp = responder.resources.flatten.select do |resource|
        resource.respond_to?(:updated_at)
      end.map do |resource|
        (resource.updated_at || Time.now).utc
      end.max

      responder.controller.response.last_modified = timestamp if timestamp
    end

    def new_record?(responder)
      responder.resource.respond_to?(:new_record?) && responder.resource.new_record?
    end
    
end

module Restfulie
  module Server
    module ActionController
      class RestfulResponder < ::ActionController::Responder
        
        CACHES = [::Expires.new, ::LastModifieds.new]
        
        def to_format
          cached = CACHES.inject(false) do |cached, cache|
            cached || cache.do_http_cache(self)
          end
          if ::ActionController::Base.perform_caching && !cached.nil?
            set_public_cache_control!
            head :not_modified if fresh = request.fresh?(controller.response)
            fresh
          else
            super
          end
        end
          
        def set_public_cache_control!
          cache_control = controller.response.headers["Cache-Control"].split(",").map {|k| k.strip }
          cache_control.delete("private")
          cache_control.delete("no-cache")
          cache_control << "public"
          controller.response.headers["Cache-Control"] = cache_control.join(', ')
        end

      end
    end
  end
end
