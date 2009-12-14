module ActionController
  class Base
    
    # renders an specific resource to xml
    # using any extra options to render it (invoke to_xml).
    def render_resource(resource, options = {}, render_options = {})
      cache_info = {:etag => resource}
      cache_info[:last_modified] = resource.updated_at.utc if resource.respond_to? :updated_at
      if stale? cache_info
        options[:controller] = self
        
        # should check every accepted content-type
        # if the resource renders to one of them, render to it ==> chama .render_to(type)
        # if it doesnt and is xml or json entao ok, chama
        # caso contrario, nao consigo... tem que jogar erro
        
        # no responder, vou chamar .json, .html e .cada_content_type_dele, alem de JA TER registrado os content_types para abreviacoes
        # ai ele vai chamar o format.xpto nesse caso com o bloco certo
        # def method_missing(symbol, &block)
        # mime_constant = symbol.to_s.upcase
        # if Mime::SET.include?(Mime.const_get(mime_constant))
        # custom(Mime.const_get(mime_constant), &block)
        # else
        # super
        # end
        # end
        
        format = (self.params && self.params[:format]) || "xml"
        formatted_resource = ["xml", "json"].include?(format) ? resource.send(:"to_#{format}", options) : resource
        render_options[format.to_sym] = formatted_resource
        render render_options
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
    
    # renders a created resource including its required headers:
    # Location and 201
    def render_created(resource, options = {})
      location= url_for resource
      render_resource resource, options, {:status => :created, :location => location}
    end
  end
end
