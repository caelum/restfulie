require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should index home" do
    assert_routing(
      { :method => :get, :path => '/' },
      { :controller => 'home', :action => 'index' }
    )

    get :index

    assert_response :success
    assert_template :index
    assert @response.content_type, 'text/html'
  end
end
