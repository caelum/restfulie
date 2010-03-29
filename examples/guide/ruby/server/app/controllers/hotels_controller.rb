class HotelsController < Restfulie::Server::ActionController::Base

  respond_to :atom, :html

  def create
    @hotel = parse_request_content
    @hotel.save!
    respond_with @hotel
  end


  def index
    @hotels = Hotel.all
    respond_to do |format|
     format.atom { render :xml => @hotels.to_atom.to_xml }
    end
    # render_collection @hotels do |item|
    #   item.to_xml :controller => self, :only => [:name, :room_count], :skip_instruct => true
    # end
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
