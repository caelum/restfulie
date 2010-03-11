class Restfulie::TemplateHandlers::Tokamak < ::ActionView::TemplateHandler
  include ::ActionView::TemplateHandlers::Compilable
    
  def compile(template)
    # "_set_controller_content_type(Mime::ATOM); " +
    template.source
  end
end

