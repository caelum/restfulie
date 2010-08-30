class BasketsController < ApplicationController

  
  include Restfulie::Server::ActionController::Base
  
  respond_to :xml, :json
  
  def create
    @basket = Basket.new
    params[:basket][:items].each do |item|
      @basket.items << Item.find(item[:id])
    end
    @basket.save
    render :text => "", :status => 201, :location => basket_url(@basket)
  end
  
  def show
    @basket = Basket.find(params[:id])
    respond_with @basket
  end


end
