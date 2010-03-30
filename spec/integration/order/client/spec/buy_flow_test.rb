require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

context Restfulie do

  before(:all) do
    Item = Restfulie.resource(:item) do |config|
      config.entry_point = 'http://localhost:4567/items'
      config.representations = {
        :atom => {
          :headers => { 
            'Accept' => 'application/atom+xml',
            'Content-Type' => 'application/atom+xml'
          },
          :payload_template => "title=#{title}"
          :payload_template => MyPayloadAtomClass
          :payload_template => lambda{ |atom| "title=#{title}" }
        },
        :xml => {
        },
        :csv => {
        }
      }
    end
    Item.get!
  end
 
  it 'should list items' do
    Item.each { |item| puts items }
  end

  it "should create order" do
    new_order = Order << Order.new
    puts new_order
  end

  it 'should add item an order' do
    new_item = Item << Item.new
    puts new_item
  end

  it 'should remove item an order' do
    removed_item = Item.remove(Item.first)
    puts removed_item
  end

  it 'should list items from an order' do
    order = Order.first
    orter.items.each { |item| puts item }
  end

  it "should change order's address" do
    order = Order.first
    order << Address.last
    puts order.address
    order << Address.first
    puts order.address
  end

  it "should start of paying an order" do
    payment = Payment.new 
    payment << Order.first
    puts payment
  end

  it "should refuse a payment" do
    payment = Payment.first
    payment.refuse
  end

  it "should approve a payment" do
    payment = Payment.first
    payment.approve
  end

  it "should not allow to pay twice" do
    payment = Payment.first
    payment.approve
    payment.approve
  end
     
end

