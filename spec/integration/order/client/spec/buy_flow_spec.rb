require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

context Restfulie do

  it 'should list items' do
    items = Restfulie.at('http://localhost:3000/items').accepts('application/atom+xml').get!
    items.each { |item| puts item } 
  end

  it 'should create order'
  it 'should add item an order'
  it 'should remove item an order'

  it 'should list items from an order' do
    order = Restfulie.at('http://localhost:3000/orders/1').accepts('application/atom+xml').get!
    order.items.each { |item| puts items }
  end

  it "should change order's address"
  it 'should start of paying an order'
  it 'should refuse a payment'
  it 'should approve a payment'
  it 'should not allow to pay twice'

end

