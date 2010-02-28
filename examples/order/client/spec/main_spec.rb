require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

context Restfulie do
  
  # how to process an order
  #
  # order = create_order
  # order.request.as('application/vnd.restbucks+xml').payment(payment(order.cost), :method => :post)
  # sleep 20
  # order.self.retrieve(:method => :delete)
  # receipt = order.self.receipt

  def new_order(where)
    {:location => where, :items => [
                {:drink => "LATTE", :milk => "SEMI", :size => "LARGE"},
                {:drink => "LATTE", :milk => "WHOLE", :size => "SMALL"}
                    ]}.to_xml(:root => "order")
  end
  
  def payment(value)
    {:amount => value, :cardholder_name => "Guilherme Silveira", :card_number => "4004", :expiry_month => 10, :expiry_year => 12}.to_xml(:root => "payment")
  end
  
  def create_order(where = "TO_TAKE")
    Restfulie.at('http://localhost:3000/orders').as('application/xml').create(new_order(where))
  end
        
  it "should create order" do
    order = create_order
    order.web_response.should be_is_successful
  end

  it "should allow crawling children" do
    order = create_order
    items = order.request.items(:method => :get)
    items[1].drink.should == "LATTE"
  end
  
  it "should load from cache" do
    order = create_order
    previous_response = order.self.web_response
    order.self.web_response.should == previous_response
  end
  
   it "should cancel an order and delete it from the database" do
     order = create_order
     cancelled = order.cancel
     cancelled.web_response.should be_is_successful
     order.self.web_response.code.should == "404"
   end
   
   it "should update an order while possible" do
     order = create_order
     order = order.update(new_order("EAT_IN"), :method => :put)
     order.web_response.is_successful?.should be_true
     order.location.should == "EAT_IN"
   end
   
   it "should complain if partially paying" do
     order = create_order
     order.request.as('application/vnd.restbucks+xml').payment(payment(1)).web_response.code.should == "400"
   end  
   
   it "should allow to pay" do
     order = create_order
     order.request.as('application/vnd.restbucks+xml').payment(payment(order.cost)).web_response.code.should == "200"
     order = order.self
     order.web_response.code.should == "200"
     order.status.should == "preparing"
   end
     
     it "should not allow cancel an order if already paid" do
       order = create_order
       order.request.as('application/vnd.restbucks+xml').payment(payment(order.cost))
       order.cancel.web_response.code.should == "405"
     end
     
     it "should not allow to pay twice" do
       order = create_order
       order.request.as('application/vnd.restbucks+xml').payment(payment(order.cost))
       order.request.as('application/vnd.restbucks+xml').payment(payment(order.cost)).web_response.code.should == "405"
     end
       
    it "should allow to take out and receive receipt" do
      order = create_order
      order.request.as('application/vnd.restbucks+xml').payment(payment(order.cost), :method => :post)
      sleep 20
      order = order.self
      order.status.should == "ready"
      order.retrieve(:method => :delete)
      Restfulie.cache_provider.clear
      order = order.self
      order.status.should == "delivered"
      receipt = order.receipt(:method => :get)
      receipt.amount.to_f.should == 20
    end
     
  
end
