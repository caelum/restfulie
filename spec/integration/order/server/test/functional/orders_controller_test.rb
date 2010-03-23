require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class OrdersControllerTest < ActionController::TestCase

  test "should create order" do
    assert_routing(
      { :method => :post, :path => '/orders' },
      { :controller => 'orders', :action => 'create' }
    )
    assert_difference('Order.count') do
      post :create, { :order => {} }, :format => 'atom' 
    end
    assert_response :success
    assert_template :create
    assert @response.content_type, 'application/atom+xml'
  end

  test "should index order" do

    orders = []
    2.times { orders << Order.create! }

    assert_routing(
      { :method => :get, :path => '/orders' },
      { :controller => 'orders', :action => 'index' }
    )

    get :index, :format => 'atom'

    assert_response :success
    assert_template :index
    assert @response.content_type, 'application/atom+xml'
    
    listed_orders = assigns(:orders)
    assert 2, listed_orders.size
    assert orders.first.id, listed_orders.first.id
    assert orders.last.id, listed_orders.last.id
  end

end
