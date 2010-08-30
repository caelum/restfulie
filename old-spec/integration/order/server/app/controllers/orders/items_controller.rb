class Orders::ItemsController < ApplicationController
  include Restfulie::Server::ActionController::Base

  respond_to :atom, :html

  def index
    respond_with @items = Item.all
  end

  def show
    respond_with @order = Order.find(params[:order_id])
  end

  def add
    @order = Order.find(params[:order_id])
    @errors = []
    ActiveRecord::Base.transaction do
      params[:items].collect do |k,item|
        begin
          @order << Item.find(item[:id])
        rescue Exception => e
          @errors << { :item => item, :exception => e }
        end
      end
    end
    if @errors.empty?
      redirect_to order_items_url(@order)
    else
      respond_with @errors, :status => :unprocessable_entity
    end
  end

end

