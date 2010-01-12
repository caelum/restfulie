require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class ClientsController < ActionController::Base
  include Restfulie::Server::Controller
  
end
class Client
end

describe Restfulie::Server::Controller do
  
  before do
    @controller = ClientsController.new
  end

  context "while preparing the request info" do
    
    it "should extract the model part from the Controller name" do
      @controller.model_type.should eql(Client)
    end
    
    it "should not fit content if it is not registered" do
      Restfulie::MediaType.should_receive(:supports?).with('vnd/my_custom+xml').and_return(false)
      @controller.fits_content(Client, 'vnd/my_custom+xml').should be_false
    end
    
    it "should not fit content if is registered for another type" do
      Restfulie::MediaType.should_receive(:supports?).with('vnd/my_custom+xml').and_return(true)
      Client.should_receive(:media_type_representations).and_return([])
      @controller.fits_content(Client, 'vnd/my_custom+xml').should be_false
    end
    
    it "should not fit content if it does not accept any custom media type" do
      Restfulie::MediaType.should_receive(:supports?).with('vnd/my_custom+xml').and_return(true)
      Client.should_receive(:respond_to?).with(:media_type_representations).and_return(false)
      @controller.fits_content(Client, 'vnd/my_custom+xml').should be_false
    end
    
    it "should fit content if it does not accept any custom media type, but its a basic one" do
      Restfulie::MediaType.should_receive(:supports?).with('application/xml').and_return(true)
      Client.should_receive(:respond_to?).with(:media_type_representations).and_return(false)
      @controller.fits_content(Client, 'application/xml').should be_true
    end
    
    it "should extract the model name from the controller name" do
      @controller.model_name.should eql("client")
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
      @controller.should_receive(:fits_content).with(Client, 'vnd/my_custom+xml').and_return(false)
      @controller.should_receive(:head).with(415).and_return(@result)
      @controller.create.should eql(@result)
    end

    it "should save models if everything goes fine" do
      model = Hashi::CustomHash.new
      model.save = true
      body = Hashi::CustomHash.new
      body.string = "xml content"
      
      @req.should_receive(:body).and_return(body)
      @controller.should_receive(:fits_content).with(Client, 'vnd/my_custom+xml').and_return(true)
      Client.should_receive(:from_xml).with(body.string).and_return(model)
      @controller.should_receive(:render_created).with(model).and_return(@result)
      @controller.create.should eql(@result)
    end

    it "render the errors if something goes wrong" do
      model = Hashi::CustomHash.new
      model.errors = Object.new
      model.save = false
      body = Hashi::CustomHash.new
      body.string = "xml content"
      @req.should_receive(:body).and_return(body)
      @controller.should_receive(:fits_content).with(Client, 'vnd/my_custom+xml').and_return(true)
      Client.should_receive(:from_xml).with(body.string).and_return(model)
      @controller.should_receive(:render).with({:xml => model.errors, :status => :unprocessable_entity}).and_return(@result)
      @controller.create.should eql(@result)
    end
    
  end
  
  context "when defining the variable name" do
    
    it "should return the name of the type downcased" do
      @controller.stub(:model_type).and_return(Client)
      @controller.model_variable_name.should eql(:@client)
    end
    
  end

    context "when retrieving a resource" do

      it "should render the resource if it exists" do
        resource = Client.new
        id = 15
        @controller.stub(:model_type).and_return(Client)
        Client.should_receive(:find).with(id).and_return(resource)
        @controller.should_receive(:render_resource).with(resource)
        @controller.should_receive(:params).and_return({:id=>id})
        @controller.show
        @controller.instance_variable_get(:@client).should eql(resource)
      end
    end

    context "when destroying a resource" do

      it "should delete the resource if it exists" do
        resource = Client.new
        id = 15
        @controller.should_receive(:model_type).and_return(Client)
        Client.should_receive(:find).with(id).and_return(resource)
        resource.should_receive(:destroy)
        @controller.should_receive(:head).with(:ok)
        @controller.should_receive(:params).and_return({:id=>id})
        @controller.destroy
      end
  end

  # test update

end