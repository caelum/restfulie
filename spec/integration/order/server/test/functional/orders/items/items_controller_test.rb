require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

class Orders::ItemsControllerTest < ActionController::TestCase
  
  test "should add items in order" do

    order = Order.create!
    items = []
    2.times { items << Item.create! }

    assert_routing(
      { :method     => :post, :path => "/orders/#{order.id}/items" },
      { :controller => 'orders/items', :action => 'create', :order_id => order.id.to_s }
    )

    post :create, 
      { :order_id => order.id.to_s, 
        :items => { 
          '0' => { :id => items.first.id }, 
          '1' => { :id => items.last.id } 
        } 
      }
    
    assert_redirected_to order_items_url(order)
    order_with_items = assigns(:order)
    assert 2, order_with_items.items.size
    assert items.first.id, order_with_items.items.first.id
    assert items.last.id, order_with_items.items.last.id

  end

end
