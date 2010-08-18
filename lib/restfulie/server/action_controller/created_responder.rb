module Restfulie
  module Server
    module ActionController
      
      # Adds support to answering as a 201 when the resource has been just created
      module CreatedResponder

        def to_format
          if (options[:status] == 201) || (options[:status] == :created)
            head :status => 201, :location => controller.url_for(resource)
          else
            super
          end
        end

      end
    end
  end
end
