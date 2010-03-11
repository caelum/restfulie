class ItemsController < ApplicationController
  
  include Restfulie::Server::Controller
  
  def index
    @items = Item.find_all_by_order_id(params[:order_id])
    render :xml => @items.to_xml(:controller => self)
  end

end
