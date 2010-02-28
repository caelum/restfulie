
class HotelsController < ApplicationController
  include Restfulie::Server::Controller

  #   as_restfulie_controller do |config|
  #   config.update.invoke_before(:pre_update)
  # end
  
  def index
    @hotels = Hotel.all
    render_collection @hotels do |item|
      item.to_xml :controller => self, :only => [:name, :room_count], :skip_instruct => true
    end
  end

  # def pre_update(hash, hotel)
  #   hotel.update_count++
  # end
  
  # callback for create, delete, show

  # PUT /hotels/1
  # PUT /hotels/1.xml
  def update
    @hotel = Hotel.find(params[:id])

    respond_to do |format|
      if @hotel.update_attributes(params[:hotel])
        flash[:notice] = 'Hotel was successfully updated.'
        format.html { redirect_to(@hotel) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @hotel.errors, :status => :unprocessable_entity }
      end
    end
  end

end
