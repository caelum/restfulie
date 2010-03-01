require 'test_helper'

class FlightsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:flights)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create flight" do
    assert_difference('Flight.count') do
      post :create, :flight => { }
    end

    assert_redirected_to flight_path(assigns(:flight))
  end

  test "should show flight" do
    get :show, :id => flights(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => flights(:one).to_param
    assert_response :success
  end

  test "should update flight" do
    put :update, :id => flights(:one).to_param, :flight => { }
    assert_redirected_to flight_path(assigns(:flight))
  end

  test "should destroy flight" do
    assert_difference('Flight.count', -1) do
      delete :destroy, :id => flights(:one).to_param
    end

    assert_redirected_to flights_path
  end
end
