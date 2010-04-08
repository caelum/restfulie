class ItemsController < ::ApplicationController
  include Restfulie::Server::ActionController::Base

  respond_to :atom, :html
  
  def index
    respond_with @items = Item.all
  end

  def new
    respond_with @item = Item.new
  end

  def create
    Item.create!(params[:item])
    redirect_to items_url
  end

  def destroy
    Item.delete(params[:id])
    redirect_to items_url
  end

end

