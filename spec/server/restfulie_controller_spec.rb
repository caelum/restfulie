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
        @controller.model_variable_name.should eql(:@schoolclient)
      end

    end

    it "should extract the model part from the Controller name" do
      @controller.model_type.should eql(SchoolClient)
    end
    
    it "should not fit content if it is not registered" do
      Restfulie::MediaType.should_receive(:supports?).with('vnd/my_custom+xml').and_return(false)
      @controller.fits_content(SchoolClient, 'vnd/my_custom+xml').should be_false
    end
    
    it "should not fit content if it does not accept any custom media type" do
      Restfulie::MediaType.should_receive(:supports?).with('vnd/my_custom+xml').and_return(true)
      @controller.fits_content(SchoolClient, 'vnd/my_custom+xml').should be_false
    end
    
    it "should fit content if it does not accept any custom media type, but its a basic one" do
      Restfulie::MediaType.should_receive(:supports?).with('application/xml').and_return(true)
      @controller.fits_content(SchoolClient, 'application/xml').should be_true
    end
    
    it "should not fit content if is registered for another type" do
      Restfulie::MediaType.should_receive(:supports?).with('vnd/my_custom+xml').and_return(true)
      def SchoolClient.media_type_representations
        []
      end
      @controller.fits_content(SchoolClient, 'vnd/my_custom+xml').should be_false
    end
    
    it "should extract the model name from the controller name" do
      @controller.model_name.should eql("school_client")
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
      @controller.create.should eql(@result)
    end

    it "render the errors if something goes wrong" do
      model = Object.new
      def model.save
        false
      end
      def model.errors
        "error-list"
      end
      body = Hashi::CustomHash.new
      def body.string
        "content"
      end
      @req.should_receive(:body).and_return(body)
      @controller.should_receive(:fits_content).with(SchoolClient, 'vnd/my_custom+xml').and_return(true)
      SchoolClient.should_receive(:from_xml).with(body.string).and_return(model)
      @controller.should_receive(:render).with({:xml => model.errors, :status => :unprocessable_entity}).and_return(@result)
      @controller.create.should eql(@result)
    end

    it "should save models if everything goes fine" do
      model = Object.new
      def model.save
        true
      end
      body = Hashi::CustomHash.new
      def body.string
        "content"
      end
      
      @req.should_receive(:body).and_return(body)
      @controller.should_receive(:fits_content).with(SchoolClient, 'vnd/my_custom+xml').and_return(true)
      SchoolClient.should_receive(:from_xml).with(body.string).and_return(model)
      @controller.should_receive(:render_created).with(model).and_return(@result)
      @controller.create.should eql(@result)
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
        @controller.instance_variable_get(:@schoolclient).should eql(resource)
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
      @controller.update.should eql(@result)
    end
    
    context "will update" do
      
      before do
        @loaded.should_receive(:can?).with(:update).and_return(true)
        @controller.should_receive(:fits_content).with(SchoolClient, 'vnd/my_custom+xml').and_return(true)
        body = Hashi::CustomHash.new({"string" => "my body"})
        @req.should_receive(:body).and_return(body)
        @client = SchoolClient.new
        model = { "school_client" => @client}
        Hash.should_receive(:from_xml).with(body.string).and_return(model)
        @loaded.should_receive(:update_attributes).with(@client).and_return(true)
        @controller.should_receive(:render_resource).with(@loaded).and_return(@result)
      end

      it "should render the resource if everything goes ok" do
        @controller.update.should eql(@result)
      end
      
      it "should invoke pre_update if available" do
        def @controller.pre_update(model)
          :nothing
        end
        @controller.should_receive(:pre_update).with(@client)
        @controller.update.should eql(@result)
      end
    
    end
    
  end

end