class PaymentsController < ApplicationController

  include Restfulie::Server::ActionController::Base
  
  respond_to :xml, :json
  
  def create
    @payment = Basket.find(params[:basket_id]).payments.create(params[:payment])
    render :text => "", :status => 201, :location => basket_payment_url(@payment.basket, @payment)
  end
  
  def show
    @payment = Payment.find(params[:id])
    respond_with @payment
  end

end
