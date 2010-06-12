module Restfulie
  module Server
    module ActionController
      
      # Adds support to answering as a 201 when the resource has been just created
      module CreatedResponder

        def to_format
          if [201, :created].include? options[:status]
            head :status => 201, :location => controller.url_for(resource)
          else
            super
          end
        end

      end
    end
  end
end
