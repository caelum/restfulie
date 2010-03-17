class ItemsController < ApplicationController
  
  def index
    @items = Item.find_all_by_order_id(params[:order_id])
    respond_to do |wants|
      wants.html
      wants.atom
    end
  end

end
