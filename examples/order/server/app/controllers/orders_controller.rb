class OrdersController < ApplicationController
  
  include Restfulie::Server::Controller

  cache.allow 2.hours

  def index
    @orders = Order.all
  end
  
  def configure_cache(model)
    cache.allow 2.hours if model.status=="ready"
  end
  
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
