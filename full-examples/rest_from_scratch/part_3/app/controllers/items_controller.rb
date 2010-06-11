class ItemsController < ApplicationController
  
  include Restfulie::Server::ActionController::Base
  
  respond_to :xml, :json
  
  def index
    @items = Item.all
    respond_with @items, :expires_in => 2.minutes
  end
  
  def create
    @item = Item.create(params[:item])
    render :text => "", :status => 201, :location => item_url(@item)
  end
  
  def show
    @item = Item.find(params[:id])
    respond_with @item
  end
  
end
