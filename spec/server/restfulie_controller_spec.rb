require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class SchoolClientsController < ActionController::Base
  include Restfulie::Server::Controller
  
end
class SchoolClient
end

describe Restfulie::Server::Controller do
  
  before do
    @controller = SchoolClientsController.new
  end

  context "while preparing the request info" do
    
    context "when defining the variable name" do

      it "should return the name of the type downcased" do
        @controller.stub(:model_type).and_return(SchoolClient)
        @controller.model_variable_name.should == :@schoolclient
      end

    end

    it "should extract the model part from the Controller name" do
      @controller.model_type.should == SchoolClient
    end
    
    it "should extract the model name from the controller name" do
      @controller.model_name.should == "school_client"
    end
    
  end
  
  context "when creating a resource" do
    
    before do
      @req = Object.new
      @req.stub(:headers).and_return({'CONTENT_TYPE' => 'vnd/my_custom+xml'})
      @controller.should_receive(:request).at_least(1).and_return(@req)
      @result = "final result"
    end

    it "should return 415 if the media type is not supported" do
      @controller.should_receive(:fits_content).with(SchoolClient, 'vnd/my_custom+xml').and_return(false)
      @controller.should_receive(:head).with(415).and_return(@result)
      @controller.create.should == @result
    end

  end

    context "when retrieving a resource" do

      it "should render the resource if it exists" do
        resource = SchoolClient.new
        id = 15
        @controller.stub(:model_type).and_return(SchoolClient)
        SchoolClient.should_receive(:find).with(id).and_return(resource)
        @controller.should_receive(:render_resource).with(resource)
        @controller.should_receive(:params).and_return({:id=>id})
        @controller.show
        @controller.instance_variable_get(:@schoolclient).should == resource
      end
    end

    context "when destroying a resource" do

      it "should delete the resource if it exists" do
        resource = SchoolClient.new
        id = 15
        @controller.should_receive(:model_type).and_return(SchoolClient)
        SchoolClient.should_receive(:find).with(id).and_return(resource)
        resource.should_receive(:destroy)
        @controller.should_receive(:head).with(:ok)
        @controller.should_receive(:params).and_return({:id=>id})
        @controller.destroy
      end
  end

  context "when updating a resource" do
    
    before do
      @id = 15
      @loaded = Object.new
      @req = Object.new
      @req.stub(:headers).and_return({'CONTENT_TYPE' => 'vnd/my_custom+xml'})
      @controller.stub(:request).and_return(@req)
      @controller.should_receive(:params).and_return({:id=>15})
      @result = "give it back"
      SchoolClient.should_receive(:find).with(15).and_return(@loaded)
    end
    
    it "should return 405 if it can not be updated" do
      @loaded.should_receive(:can?).with(:update).and_return(false)
      @controller.should_receive(:head).with(:status => 405)
      @controller.update
    end
    
    it "should return 415 if the media type is not supported" do
      @loaded.should_receive(:can?).with(:update).and_return(true)
      @controller.should_receive(:fits_content).with(SchoolClient, 'vnd/my_custom+xml').and_return(false)
      @controller.should_receive(:head).with(415).and_return(@result)
      @controller.update.should == @result
    end
    
  end

end
