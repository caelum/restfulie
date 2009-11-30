require 'restfulie'

module Restfulie
  module Server
   module Controller

    # renders an specific resource to xml
    # using any extra options to render it (invoke to_xml).
    def render_resource(resource, options={})
      options[:controller] = self
      options[:xml] = resource.to_xml options
      render options
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

module ActionController
  class Base
    include Restfulie::Server::Controller
  end
end
