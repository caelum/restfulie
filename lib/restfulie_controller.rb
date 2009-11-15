require 'restfulie'

module RestfulieController
end
module ActionController
  class Base
    alias_method :simple_render, :render
    def render(options={})
      return simple_render(options) unless options[:resource]
      resulting_xml = options[:resource].to_xml(:controller => self)
      simple_render :xml => resulting_xml
    end
  end
end
