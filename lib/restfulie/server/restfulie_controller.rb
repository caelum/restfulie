module Restfulie
  
  module Controller
    
    def create
      
      type = model_for_this_controller
      unless Restfulie::MediaType.supports?(request.headers['CONTENT_TYPE']) ||
              Restfulie::MediaType.media_type(request.headers['CONTENT_TYPE']) == type
        return head 415
      end
      
      @model = Restfulie.from request
      if @model.save
        render_created @model
      else
        render :xml => @model.errors, :status => :unprocessable_entity
      end
      
    end
    
    def model_for_this_controller
      self.class.name[/(.*)Controller/,1].singularize.constantize
    end
    
  end
  
end