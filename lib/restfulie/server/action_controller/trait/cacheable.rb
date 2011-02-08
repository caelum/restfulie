class Expires
  def do_http_cache(responder, headers)
    if responder.options[:expires_in]
      headers << "max-age=#{responder.options[:expires_in]}"
      true
    else
      false
    end
  end
end

class LastModifieds
  # default implementation that will check whether caching can be applied
  def accepts?(responder)
    responder.resources.flatten.select do |resource|
      resource.respond_to?(:updated_at)
    end &&
      responder.controller.response.last_modified.nil? &&
      !new_record?(responder)
  end

  def do_http_cache(responder, headers)
    return false unless accepts?(responder)
    
    timestamps = responder.resources.flatten.select do |resource|
      resource.respond_to?(:updated_at)
    end.map do |resource|
      (resource.updated_at || Time.now).utc
    end
    
    timestamp = timestamps.max

    responder.controller.response.last_modified = timestamp if timestamp
  end

  def new_record?(responder)
    responder.resource.respond_to?(:new_record?) && responder.resource.new_record?
  end
    
end

module Restfulie::Server::ActionController
  module Trait
    module Cacheable
      
      def to_format

        cache_request()

        if is_cached?
          set_public_cache_control(headers)
          controller.response.headers["Cache-Control"] = headers.join(', ')
          fresh = request.fresh?(controller.response)
          if fresh
            head :not_modified
          else
            super
          end
        else
          super
        end
      end

      def caches
        [::Expires.new, ::LastModifieds.new]
      end


      private

      def cache_request
        headers = cache_control_headers
        cached = caches.inject(false) do |cached, cache|
          cached || cache.do_http_cache(self, headers)
        end
      end

      def is_cached?
        ::ActionController::Base.perform_caching && cached
      end

      def set_public_cache_control(headers)
        headers.delete("private")
        headers.delete("no-cache")
        headers << "public"
      end
      
      def cache_control_headers
        (controller.response.headers["Cache-Control"] || "").split(",").map {|k| k.strip }
      end

    end
  end
end
