module Restfulie::TemplateHandlers #:nodoc:
end

require 'restfulie/server/action_pack/action_view/template_handlers/tokamak'

if defined? ActionView::Template and ActionView::Template.respond_to? :register_template_handler
  ActionView::Template
else
  ActionView::Base
end.register_template_handler(:tokamak, Restfulie::TemplateHandlers::Tokamak)

ActionController::Base.exempt_from_layout :tokamak if defined? ActionController::Base

