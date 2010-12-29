module Restfulie
  module Server
    module ActionView

      module Helpers
        # Load a partial template to execute in describe
        #
        # For example:
        #
        # Passing the current context to partial in template:
        #
        #  member(@album) do |member, album|
        #    partial('member', binding)
        #  end
        #
        # in partial:
        #
        #  member.links << link(:rel => :artists, :href => album_artists_url(album))
        #
        # Or passing local variables assing
        #
        # collection(@albums) do |collection|
        #   collection.members do |member, album|
        #     partial("member", :locals => {:member => member, :album => album})
        #   end
        # end
        #
        def partial(partial_path, caller_binding = nil)
          # Code originally from older Restfulien and Tokamak
          template = _pick_partial_template(partial_path)

          # Create a context to assing variables
          if caller_binding.kind_of?(Hash)
            Proc.new do
              extend @content_type_helpers
              context = eval("(class << self; self; end)", binding)

              unless caller_binding[:locals].nil?
                caller_binding[:locals].each do |k, v|
                  context.send(:define_method, k.to_sym) { v }
                end
              end

              partial(partial_path, binding)
            end.call
          else
            eval(template.source, caller_binding, template.path)
          end
        end
      end

      if defined? ::ActionView::Template and ::ActionView::Template.respond_to?(:register_template_handler)
        ::ActionView::Template
      else
        ::ActionView::Base
      end.register_template_handler(:tokamak, Tokamak)

      if defined? ::ActionController::Base
        ::ActionController::Base.exempt_from_layout :tokamak
      end

      module TemplateHandlers
        class Tokamak < ::ActionView::TemplateHandler
          include ::ActionView::TemplateHandlers::Compilable
            
          def compile(template)
            "@type_helpers = Tokamak::builder_lookup(self.response.content_type).helper; " +
            "extend @type_helpers; " +
            "extend Restfulie::Server::ActionView::Helpers; " +
            "code_block = lambda { #{template.source} };" + 
            "builder = code_block.call; " +
            "self.response.headers['Link'] = Restfulie::Common.extract_link_header(builder.links) if builder.respond_to?(:links); " +
            "builder"
          end
        end
      end
    end
  end
end