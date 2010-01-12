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
        render_resource(@model)
      end
      
      def model_variable_name
        ("@" + model_type.to_s.downcase).to_sym
      end

      # destroys this resource
      def destroy
        @model = model_type.find(params[:id])
        @model.destroy
        head :ok
      end

      # updates a resouce
      def update
        @loaded = model_type.find(params[:id])
        return head :status => 405 unless @loaded.can? :update

        type = model_type
        return head 415 unless fits_content(type, request.headers['CONTENT_TYPE'])

        @model = Hash.from_xml(request.body.string)[model_name]
        pre_update(@model) if self.respond_to?(:pre_update)
        
        if @loaded.update_attributes(@model)
          render_resource @loaded
        else
          render :xml => @loaded.errors, :status => :unprocessable_entity
        end
      end

      # returns the model for this controller
      def model_type
        self.class.name[/(.*)Controller/,1].singularize.constantize
      end
      
      # retrieves the model name
      def model_name
        self.class.name[/(.*)Controller/,1].singularize.underscore
      end
    
      def fits_content(type, content_type)
        Restfulie::MediaType.supports?(content_type) &&
                (type.respond_to?(:media_type_representations) ?
                type.media_type_representations.include?(content_type) :
                Restfulie::MediaType.default_representations.include?(content_type))
      end
    
    end
    
  end
  
end