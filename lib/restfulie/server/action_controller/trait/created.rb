module Restfulie::Server::ActionController
  module Trait
    
    # Adds support to answering as a 201 when the resource has been just created
    module Created

      def to_format
        if (options[:status] == 201) || (options[:status] == :created)
          render :status => 201, :location => controller.url_for(resource), :text => ""
        else
          super
        end
      end

    end
  end
end
