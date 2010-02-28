require 'test_helper'

class OrdersControllerTest < ActionController::TestCase

  test "should create order" do
    assert_difference('Order.count') do
      as('application/xml').raw_post(:create, {}, "<order></order>")
    end

    assert_created order_url(assigns(:model))
  end

  # test "should show order" do
  #   get :show, :id => orders(:one).to_param
  #   assert_response :success
  # end
  # 
  # test "should update order" do
  #   put :update, :id => orders(:one).to_param, :order => { }
  #   assert_redirected_to order_path(assigns(:order))
  # end
  # 
  # test "should destroy order" do
  #   assert_difference('Order.count', -1) do
  #     delete :destroy, :id => orders(:one).to_param
  #   end
  # 
  #   assert_redirected_to orders_path
  # end
end
