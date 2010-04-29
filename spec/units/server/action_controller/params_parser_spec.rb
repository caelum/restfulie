require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "action_controller"

class TestController < ::ActionController::Base
  include Restfulie::Server::ActionController::Base
  def create
    render :text => (params.keys - ['controller', 'action']).sort.join(", ")
  end
end

class NormalController < ::ActionController::Base
  def build
    render :text => (params.keys - ['controller', 'action']).sort.join(", ") 
  end
end

class CSVRepresentation
  cattr_reader :media_type_name
  @@media_type_name = 'text/csv'

  cattr_reader :headers
  @@headers = { 
    :get  => { 'Accept'       => media_type_name },
    :post => { 'Content-Type' => media_type_name }
  }

  def self.to_hash(string)
    { :data => string }.with_indifferent_access
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

  def test_simple_getting
    with_test_route_set do
      get '/create', :sort => true

      assert_equal 'sort', @controller.response.body
      assert @controller.params.has_key?(:sort)
      assert_equal "true", @controller.params["sort"]
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

 def test_offer_proper_params_hash_when_doing_post_with_atom 
    with_test_route_set do
      post '/create', 
        '<feed xmlns="http://www.w3.org/2005/Atom"><title>Top Ten Songs feed</title><id>http://local/songs_top_ten</id><updated>2010-12-13T18:30:02Z</updated></feed>',
        :content_type => 'application/atom+xml'

      assert_equal 'feed', @controller.response.body
      assert @controller.params.has_key?(:feed)
      assert_equal 'Top Ten Songs feed', @controller.params["feed"]['title']
    end
  end

  def test_raise_bad_request_when_doing_post_with_invalid_atom 
    with_test_route_set do
      begin
        $stderr = StringIO.new
        log_io = StringIO.new
        ::ActionController::Base.logger = Logger.new(log_io)

        post '/create', 
          '<feed xmlns="http://www.w3.org/2005/Atom">Top Ten Songs feed</title><id>http://local/songs_top_ten</id></feed>',
          :content_type => 'application/atom+xml'

        assert_response :bad_request
        assert_match /400 Bad Request/, log_io.string 
        $stderr.rewind 
      ensure
        $stderr = STDERR
      end
    end
  end

  def test_unsupported_media_type_when_doing_post_with_csv
    with_test_route_set do
      log_io = StringIO.new
      ::ActionController::Base.logger = Logger.new(log_io)

      post '/create', 'name,age\njohndoe,42', 
        :content_type => 'text/csv'

      assert_response :unsupported_media_type
      assert_match /415 Unsupported Media Type/, log_io.string 
    end
  end

  def test_posting_with_csv_after_registering_it_as_supported_type
    Restfulie::Server::ActionController::ParamsParser.register('text/csv',CSVRepresentation)
    with_test_route_set do
      post '/create', 'name,age\njohndoe,42', 
        :content_type => 'text/csv'

      assert_equal 'data', @controller.response.body
      assert @controller.params.has_key?(:data)
      assert_equal 'name,age\njohndoe,42', @controller.params["data"]
    end
    Restfulie::Server::ActionController::ParamsParser.unregister('text/csv')
  end

  def test_normal_controller_should_behave_just_as_any_rails_controller 
    with_test_route_set do
      post '/build', 
        'foo=1',
        :content_type => 'application/x-www-form-urlencoded'

      assert_equal 'foo', @controller.response.body
      assert @controller.params.has_key?(:foo)
      assert_equal "1", @controller.params["foo"]
    end
  end

  private
    def with_test_route_set
      with_routing do |set|
        set.draw do |map|
          map.with_options :controller => "test" do |c|
            c.connect "/create", :action => "create"
          end
          map.with_options :controller => "normal" do |c|
            c.connect "/build", :action => "build"
          end
        end
        yield
      end
    end
  
end
