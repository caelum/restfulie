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
class Restfulie::Server::Transition
      
    include ActionController::UrlWriter

    # return the link to this transitions's uri
    def link_for(model, controller)
      specific_action = @body ? @body.call(model) : action.dup

      specific_action = parse_specific_action(specific_action, model)

      rel = specific_action[:rel] || @name
      specific_action[:rel] = nil

      specific_action[:action] ||= @name
      specific_action[:host] = Restfulie::Server.host
      debugger
      uri = url_for(specific_action)
      uri = controller.url_for(specific_action)
      
      return rel, uri
    end
end

class OrdersController < ApplicationController
  
  inherit_restfulie
  include Restfulie::Server::Controller

  cache.allow 2.hours

  def index
    @orders = Order.all
  end
  
  # def respond_with(*resources, &block)
  #   response.headers['Cache-control'] = "max-age=#{self.class.cache.max_age}"
  #   return nil unless (resource.nil? || !resource.kind_of?(Array) || stale?(resource.cache_info))
  # 
  #   super(resources, &block)
  # end

  def destroy
    @model = model_type.find(params[:id])
    if @model.can? :cancel
      @model.delete
      head :ok
    elsif @model.can? :retrieve
      @model.status = "delivered"
      @model.save!
      head :ok
    else
      head :status => 405
    end
  end
  
  def pre_update(model)
    model[:status] = "unpaid"
    model["items"] = model["items"].map do |item|
      Item.new(item)
    end
  end

end
