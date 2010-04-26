require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

context Restfulie do

  before(:all) do
    Restfulie.recipe(:atom, :name => :item) do |item,entry|
      entry.id      = item[:id]
      entry.title   = item[:title]
      entry.updated = item[:updated]
      #entry.kind    = item[:kind]
      #entry.qt      = item[:qt]
      #entry.price   = item[:price]
    end

  end

  it 'should create items' do
    new_item = {
      :id      => Time.now.to_i,
      :title   => 'Towel Package',
      :updated => Time.now,
      :kind    => 'bath',
      :qt      => 2,
      :price   => 1.5
    }
    Restfulie.at('http://localhost:3000/items').accepts('application/atom+xml').post!(new_item, :recipe => :item)
  end

  #it 'should list items' do
    #items = Restfulie.at('http://localhost:3000/items').accepts('application/atom+xml').get!
    #puts items
  #end

  it 'should create order'
  it 'should add item an order'
  it 'should remove item an order'
  it 'should list items from an order'
  it "should change order's address"
  it 'should start of paying an order'
  it 'should refuse a payment'
  it 'should approve a payment'
  it 'should not allow to pay twice'

end

