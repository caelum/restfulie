module Restfulie::Server::ActionView::Helpers
  # Load a partial template to execute in describe
  #
  # For example:
  #
  # Passing the current context to partial in template:
  #
  #  describe_member(@album) do |member, album|
  #    partial('member', binding)
  #  end
  #
  # in partial:
  #
  #  member.links << link(:rel => :artistis, :href => album_artists_url(album))
  #
  # Or passing local variables assing
  #  
  #  descirbe_collection(@albums) do |collection|
  #    collection.describe_members do |member, album|
  #      partial('member', :locals => {:member => member, :album => album})
  #    end
  #  end
  #
  def partial(partial_path, caller_binding = nil)
    template = _pick_partial_template(partial_path)

    # Create a context to assing variables
    if caller_binding.kind_of?(Hash)
      Proc.new do
        extend Restfulie::Common::Builder::Helpers
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