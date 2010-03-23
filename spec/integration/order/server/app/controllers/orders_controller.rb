class OrdersController < Restfulie::Server::ActionController::Base

  respond_to :atom, :html

  def index
    respond_with @orders = Order.all
  end

  def create
    respond_with @order = Order.create!
  end

end

