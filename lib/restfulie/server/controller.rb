module Restfulie
  module Server
   module Controller

    # renders an specific resource to xml
    # using any extra options to render it (invoke to_xml).
    def render_resource(resource, options={})
      cache_info = {:etag => resource}
      cache_info[:last_modified] = resource.updated_at if resource.respond_to? :updated_at
      if stale? cache_info
        options[:controller] = self
        options[:xml] = resource.to_xml options
        render options
      end
    end
  
    # adds support to rendering resources, i.e.:
    # render :resource => @order, :with => { :except => [:paid_at] }
    def render(options = {})
      resource = options[:resource]
      if resource
        render_resource(resource, options[:with])
      else
        super(options)
      end
    end

   end
  end
end

ActionController::Base.send :include, Restfulie::Server::Controller
