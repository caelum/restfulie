if defined? ::ActionView and ::ActionController
  module Restfulie #:nodoc:
    module Server #:nodoc:
      module ActionView #:nodoc:
        autoload :TemplateHandlers, 'restfulie/server/action_view/template_handlers'
        autoload :Helpers, 'restfulie/server/action_view/helpers'
      end
    end
  end
end
