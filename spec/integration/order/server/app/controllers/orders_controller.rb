class OrdersController < Restfulie::Server::ActionController::Base

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
    Order.delete(params[:id])
    redirect_to orders_url
  end

end

