class OrdersController < ApplicationController

  #GET http://localhost:4567/orders
  #ALL ORDERS
  def index
    @orders = Order.all
    respond_to do |wants|
      wants.html
      wants.atom
    end
  end

  #POST http://localhost:4567/orders
  #CREATE
  def create
    @order = Order.create!
    respond_to do |wants|
      wants.html
      wants.atom
    end
  end

  #POST http://localhost:4567/orders/:id
  #ADD ITEM
  def update
    @order = Order.find(params[:id])
    item = @request.payload.unmarshal
    @order << item
    respond_to do |wants|
      wants.html
      wants.atom
    end
  end

end

