class OrdersController < ApplicationController
  include Restfulie::Server::ActionController::Base

  respond_to :atom, :html

  def index
    respond_with @orders = Order.all
  end

  def new
    respond_with @order = Order.new
  end

  def create
    respond_with @order = Order.create!
  end

  def destroy
    if Order.delete(params[:id]) != 0
      respond_with("", :status => :success) do |format|
        format.html { redirect_to orders_url }
        format.atom { render :text => "" }
      end
    else
      respond_with() do |format|
        format.html { redirect_to orders_url }
        format.atom { render :text => "", :status => :conflict }
      end
    end
  end

end

