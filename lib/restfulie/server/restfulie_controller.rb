module Restfulie
  
  module Server
  
    # Controller which adds default CRUD + search + other operations.
    module Controller
    
      # creates a model based on the request media-type extracted from its content-type
      # 
      def create

        type = model_type
        return head 415 unless fits_content(type, request.headers['CONTENT_TYPE'])

        @model = type.from_xml request.body.string
        if @model.save
          render_created @model
        else
          render :xml => @model.errors, :status => :unprocessable_entity
        end

      end
    
      # renders this resource
      def show
        @model = model_type.find(params[:id])
        instance_variable_set(model_variable_name, @model)
        @model ? render_resource(@model) : head(404)
      end
      
      def model_variable_name
        ("@" + model_type.to_s.downcase).to_sym
      end

      # destroys this resource
      def destroy
        @model = model_type.find(params[:id])
        if @model
          @model.destroy
          head :ok
        else
          head 404
        end
      end

      # returns the model for this controller
      def model_type
        self.class.name[/(.*)Controller/,1].singularize.constantize
      end
    
      def fits_content(type, content_type)
        Restfulie::MediaType.supports?(content_type) &&
                type.media_type_representations.include?(content_type)
      end
    
    end
    
  end
  
end