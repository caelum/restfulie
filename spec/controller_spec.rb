require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class BaseController
  attr_reader :rendered
  def render(options={})
    @rendered = options
  end
end

class ClientsController < BaseController
  include Restfulie::Server::Controller
end


context Restfulie::Server::Controller do
  
  before do
    @controller = ClientsController.new
  end

  context "when generic rendering a resource" do
  
    it "should invoke the original rendering process if there is no resource" do
      options = {:custom => :whatever}
      @controller.render(options)
      @controller.rendered.should eql(options)
    end
  
  end

end