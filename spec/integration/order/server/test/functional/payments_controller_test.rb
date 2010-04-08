require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class PaymentsControllerTest < ActionController::TestCase

  test 'should list payments' do  

    payments = []
    2.times do
      order = Order.create! 
      order << Item.create!
      payments << order.pay
    end

    assert_routing(
      { :method => :get, :path => '/payments' },
      { :controller => 'payments', :action => 'index' }
    )

    get :index, :format => 'atom'

    assert_response :success
    assert_template :index
    assert @response.content_type, 'application/atom+xml'
    
    listed_payments = assigns(:payments)
    assert 2, listed_payments.size
    assert payments.first.id, listed_payments.first.id
    assert payments.last.id, listed_payments.last.id 
  end

  test "should create payment" do
    order = Order.create!
    order << Item.create!
    assert_routing(
      { :method => :post, :path => "/payments/order/#{order.id}" },
      { :controller => 'payments', :action => 'pay', :id => order.id.to_s}
    )
    assert_difference('Payment.count') do
      post :pay, { :id => order.id }, :content_type => 'application/atom+xml' 
    end
    assert @response.content_type, 'application/atom+xml'
    assert_response :success
    assert_template :pay
    payment = assigns(:payment)
    assert order.id, payment.order.id
  end

  test 'should approve payment' do
    order = Order.create!
    order << Item.create!
    payment = order.pay
    assert_routing(
      { :method => :post, :path => "/payments/#{payment.id}" },
      { :controller => 'payments', :action => 'approve', :id => payment.id.to_s }
    )
    post :approve, { :id => order.id }, :fortmat => 'atom'
    assert_response :success
    assert_template :approve
    assert @response.content_type, 'application/atom+xml'
    payment = assigns(:payment)
    assert payment.approved?
  end

  test 'should refuse payment' do
    order = Order.create!
    order << Item.create!
    payment = order.pay
    assert_routing(
      { :method => :delete, :path => "/payments/#{payment.id}" },
      { :controller => 'payments', :action => 'refuse', :id => payment.id.to_s }
    )
    delete :refuse, { :id => order.id }, :fortmat => 'atom'
    assert_response :success
    assert_template :refuse
    assert @response.content_type, 'application/atom+xml'
    payment = assigns(:payment)
    assert payment.refused?
  end

end

