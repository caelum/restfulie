class PaymentsController < ApplicationController

  #POST http://localhost:4567/payments/
  def create
    @payment = Payment.create!(:order_id => params[:order_id])
    respond_to do |wants|
      wants.html
      wants.atom
    end
  end

  #POST http://localhost:4567/payments/:id
  def approve
    @payment = Payment.find(params[:id])
    @payment.approve!
    respond_to do |wants|
      wants.html
      wants.atom
    end
  end

  #DELETE http://localhost:4567/payments/:id
  def refuse
    @payment = Payment.find(params[:id])
    @payment.refuse!
    respond_to do |wants|
      wants.html
      wants.atom
    end
  end

end

