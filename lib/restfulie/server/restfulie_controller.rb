module Restfulie
  
  module Server
  
    module Controller
    
      # creates a model based on the request media-type extracted from its content-type
      # 
      def create

        type = model_for_this_controller
        return head 415 unless fits_content(type, request.headers['CONTENT_TYPE'])

        @model = type.from_xml request.body.string
        if @model.save
          render_created @model
        else
          render :xml => @model.errors, :status => :unprocessable_entity
        end

      end
    
      def model_for_this_controller
        self.class.name[/(.*)Controller/,1].singularize.constantize
      end
    
      def fits_content(type, content_type)
        Restfulie::MediaType.supports?(content_type) &&
                type.media_type_representations.include?(content_type)
      end
    
    end
    
  end
  
end