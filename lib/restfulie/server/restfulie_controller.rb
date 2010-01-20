#
#  Copyright (c) 2009 Caelum - www.caelum.com.br/opensource
#  All rights reserved.
# 
#  Licensed under the Apache License, Version 2.0 (the "License"); 
#  you may not use this file except in compliance with the License. 
#  You may obtain a copy of the License at 
#  
#   http://www.apache.org/licenses/LICENSE-2.0 
#  
#  Unless required by applicable law or agreed to in writing, software 
#  distributed under the License is distributed on an "AS IS" BASIS, 
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
#  See the License for the specific language governing permissions and 
#  limitations under the License. 
#

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
        type = model_type

        @loaded = type.find(params[:id])
        return head :status => 405 unless @loaded.can? :update

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