require 'restfulie'

module ActionController
  # class Base
  #   alias_method :simple_render, :render
  #   def render(options={})
  #     debugger
  #     if options[:xml]
  #       resource = options[:xml]
  #       debugger
  #       return simple_render(options) if resource.kind_of?(String) || !resource.class.respond_to?(:is_acting_as_restfulie)
  #       options[:xml] = resource.to_xml(:controller => self)
  #     end
  #     simple_render(options)
  #   end
  # end
end
