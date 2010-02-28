require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class Hotel < ActiveRecord::Base
	uses_restfulie
end

context Restfulie do
  context "when using an entry point" do
      
      it "should allow access to header result" do
        hotel = {:name => "Caelum Objects Hotel", :city => "Sao Paulo", :room_count => 3, :rate => 4}
        hotel = Restfulie.at('http://localhost:3000/hotels').as('vnd/caelum_hotel+xml').accepts('application/xml').create(hotel.to_xml(:root => "hotel"))
        hotel.web_response.kind_of?(Net::HTTPResponse).should be_true
        hotel.web_response.should be_is_successful
        hotel.name.should == "Caelum Objects Hotel"
        hotel.city.should == "Sao Paulo"
        hotel.room_count.should == "3"
        hotel.rate.should == "4"
      end
      
      # it "should allow content xml while retrieving" do
      #   hotel = Restfulie.at('http://localhost:3000/hotels/1').accepts('application/xml').get
      #   hotel.web_response.kind_of?(Net::HTTPResponse).should be_true
      #   hotel.web_response['Content-type'].should begin_with('application/xml')
      #   hotel.name.should == "Caelum Objects Hotel"
      # end
      # 
      # it "should allow content negotiation while retrieving" do
      #   hotel = Restfulie.at('http://localhost:3000/hotels/1').accepts('vnd/caelum_hotel+xml').get
      #   hotel.web_response.kind_of?(Net::HTTPResponse).should be_true
      #   hotel.web_response['Content-type'].should begin_with('vnd/caelum_hotel+xml')
      #   hotel.name.should == "Caelum Objects Hotel"
      # end
      
    end
  #   
  #   context "when using an specific model" do
  #     
  #     it "should deserialize from the web" do
  #       hotel = Hotel.from_web 'http://localhost:3000/hotels/1'
  #       hotel.web_response.kind_of?(Net::HTTPResponse).should be_true
  #       hotel.web_response['Content-type'].should begin_with('application/xml')
  #       hotel.name.should == "Caelum Objects Hotel"
  #     end
  #       
  #   it "should deserialize from the web using the extension pattern from rails" do
  #     # although unRESTful, we give support to rails 'extension' format
  #     hotel = Hotel.from_web 'http://localhost:3000/hotels/1.xml'
  #     hotel.web_response.kind_of?(Net::HTTPResponse).should be_true
  #     hotel.web_response['Content-type'].should begin_with('xml')
  #     hotel.name.should == "Caelum Objects Hotel"
  #   end
  #   
  # end
            # 
            # context "when requesting an hotel feed" do
            #   
            #   it "should deserialize from the web" do
            #     hotels = Hotel.from_web 'http://localhost:3000/hotels'
            #     hotels.web_response.kind_of?(Net::HTTPResponse).should be_true
            #     hotels.web_response['Content-type'].should begin_with('application/atom+xml')
            #     hotels[0].name.should == "Caelum Objects Hotel"
            #   end
            #   
            #   it "should allow the self method to retrieve the resource itself" do
            #     hotels = Restfulie.at('http://localhost:3000/hotels').get
            #     hotels[0].name.should == "Caelum Objects Hotel"
            #     hotel = hotels[0].self
            #     hotel.room_count.should == "3"
            #   end
            # 
            #   it "should allow resource delete through the destroy method" do
            #     hotels = Restfulie.at('http://localhost:3000/hotels').get
            #     hotel = hotels[1]
            #     res = hotel.destroy
            #     hotel.self.web_response.code.should == "404"
            #   end
            #   
            #   it "should return 304 if there is no change" do
            #     hotels = Restfulie.at('http://localhost:3000/hotels').get
            #     hotels = hotels.self
            #     hotels.self.web_response.code.should == "304"
            #     hotel = hotels[1].self
            #     hotel.self.web_response.code.should == "304"
            #   end
            #                    
            # end
            
end