module Restfulie
  module Server
    module ActionController
      class RestfulResponder < ::ActionController::Responder
        def to_format
          return if do_http_cache? && do_http_cache!
          super
        end
          
        protected
          def do_http_cache!
            timestamp = resources.flatten.select do |resource|
              resource.respond_to?(:updated_at)
            end.map do |resource|
              (resource.updated_at || Time.now).utc
            end.max
      
            controller.response.last_modified = timestamp if timestamp
            set_public_cache_control!
      
            head :not_modified if fresh = request.fresh?(controller.response)
            fresh
          end
      
          def do_http_cache?
            get? && 
              @http_cache != false && 
              ::ActionController::Base.perform_caching &&
              !new_record? && 
              controller.response.last_modified.nil?
          end
      
          def new_record?
            resource.respond_to?(:new_record?) && resource.new_record?
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
