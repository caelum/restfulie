class PaymentsController < ApplicationController
  
  include Restfulie::Server::Controller
  
  def payment_url(p)
    show_payment_url(p.order)
  end

  def create

    type = model_type
    return head(415) unless fits_content(type, request.headers['CONTENT_TYPE'])

    # TODO could be Order.build_payment... do it automatically
    @model = type.from_xml request.body.string
    @model.order = Order.find(params[:order_id])
    # debugger
    if @model.order.status != "unpaid"
      head 405
    elsif @model.amount != @model.order.cost
      head :bad_request
    else
      @model.order.status = "preparing"
      if @model.save && @model.order.save
        render_created @model
      else
        render :xml => @model.errors, :status => :unprocessable_entity
      end
    end

  end
  
  def show
    order = Order.find(params[:order_id])
    render_resource order.payment
  end
  
  def receipt
    order = Order.find(params[:order_id])
    render :xml => order.payment.to_xml(:only => [:amount, :created_at], :root => :receipt), :content_type => "application/xml"
  end
  
end
