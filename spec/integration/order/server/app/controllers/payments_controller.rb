class PaymentsController < Restfulie::Server::ActionController::Base

  respond_to :atom,:html

  def index 
    respond_with @payments = Payment.all
  end

  def pay
    @order = Order.find(params[:id])
    @payment = Payment.create!(:order => @order)
    respond_with @payment
  end

  def approve
    @payment = Payment.find(params[:id])
    @payment.approve!
    respond_with @payment
  end

  def refuse
    @payment = Payment.find(params[:id])
    @payment.refuse!
    respond_with @payment
  end

end

