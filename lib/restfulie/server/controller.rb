module ActionController
  class Base
    # renders an specific resource to xml
    # using any extra options to render it (invoke to_xml).
    def render_resource(resource, options = {})
      cache_info = {:etag => resource}
      cache_info[:last_modified] = resource.updated_at if resource.respond_to? :updated_at
      if stale? cache_info
        options[:controller] = self
        format = (self.params && self.params[:format]) || "xml"
        if ["xml", "json"].include?(format)
          render format.to_sym => resource.send(:"to_#{format}", options)
        else
          render format.to_sym => resource
        end
      end
    end

    # adds support to rendering resources, i.e.:
    # render :resource => @order, :with => { :except => [:paid_at] }
    alias_method :old_render, :render
    def render(options = nil, extra_options = {}, &block)
      resource = options[:resource] unless options.nil?
      unless resource.nil?
        render_resource(resource, options[:with])
      else
        old_render(options, extra_options)
      end
    end
  end
end
