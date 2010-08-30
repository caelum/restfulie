require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class OrdersControllerTest < ActionController::TestCase

  test "should create order" do
    assert_routing(
      { :method => :post, :path => '/orders' },
      { :controller => 'orders', :action => 'create' }
    )
    assert_difference('Order.count') do
      @request.accept = "application/atom+xml"
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

    @request.accept = "application/atom+xml"
    get :index, :format => 'atom'

    assert_response :success
    assert_template :index
    assert @response.content_type, 'application/atom+xml'
    
    listed_orders = assigns(:orders)
    assert 2, listed_orders.size
    assert orders.first.id, listed_orders.first.id
    assert orders.last.id, listed_orders.last.id
  end

  test "should destroy order with atom format" do
    orders = []
    2.times { orders << Order.create! }

    assert_routing(
      { :method => :delete, :path => "/orders/#{orders.first.id}" },
      { :controller => 'orders', :action => 'destroy', :id => "#{orders.first.id}" }
    )

    delete :destroy, :id => orders.first.id, :format => 'atom'

    assert_response :success
  end

  test "should destroy order with html format" do
    orders = []
    2.times { orders << Order.create! }

    assert_routing(
      { :method => :delete, :path => "/orders/#{orders.first.id}" },
      { :controller => 'orders', :action => 'destroy', :id => "#{orders.first.id}" }
    )

    delete :destroy, :id => orders.first.id, :format => 'html'

    assert_response :found
    assert @response.content_type, 'text/html'
  end

  test "should try to destroy order, but fails in atom format" do
    orders = []
    orders << Order.create! 

    assert_routing(
      { :method => :delete, :path => "/orders/#{orders.first.id}" },
      { :controller => 'orders', :action => 'destroy', :id => "#{orders.first.id}" }
    )

    delete :destroy, :id => (orders.first.id - 1), :format => 'atom'

    assert_response :conflict
    #assert @response.content_type, 'text/html'
  end

  test "should try to destroy order, but fails in html format" do
    orders = []
    orders << Order.create! 

    assert_routing(
      { :method => :delete, :path => "/orders/#{orders.first.id}" },
      { :controller => 'orders', :action => 'destroy', :id => "#{orders.first.id}" }
    )

    delete :destroy, :id => (orders.first.id - 1), :format => 'html'

    assert_response :found
    assert @response.content_type, 'text/html'
  end


end
