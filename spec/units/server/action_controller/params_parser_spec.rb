require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

class TestController < Restfulie::Server::ActionController::Base
  def create
    render :text => (params.keys - ['controller', 'action']).sort.join(", ") 
  end
end

# This test uses ActionController::IntegrationTest because we needed a specific implementation of the post test method, which accepts a payload passed as string, and not only a hash.
class ParamsParserTest < ActionController::IntegrationTest

  def setup
    ActionController::Base.session_store = nil
  end

  def teardown
    ActionController::Base.session_store = ActionController::Session::CookieStore
  end

  def test_offer_proper_params_hash_when_doing_post_with_atom 
    with_test_route_set do
      post '/create', 
        '<feed xmlns="http://www.w3.org/2005/Atom"><title>Top Ten Songs feed</title><id>http://local/songs_top_ten</id></feed>',
        :content_type => 'application/atom+xml'

      assert_equal 'feed', @controller.response.body
      assert @controller.params.has_key?(:feed)
      assert_equal 'Top Ten Songs feed', @controller.params["feed"]['title']
    end
  end

  def test_offer_proper_params_hash_when_doing_post_with_xml 
    with_test_route_set do
      post '/create', 
        '<feed xmlns="http://www.w3.org/2005/Atom"><title>Top Ten Songs feed</title><id>http://local/songs_top_ten</id></feed>',
        :content_type => 'application/xml'

      assert_equal 'feed', @controller.response.body
      assert @controller.params.has_key?(:feed)
      assert_equal 'Top Ten Songs feed', @controller.params["feed"]['title']
    end
  end

  private
    def with_test_route_set
      with_routing do |set|
        set.draw do |map|
          map.with_options :controller => "test" do |c|
            c.connect "/create", :action => "create"
          end
        end
        yield
      end
    end
  
end
