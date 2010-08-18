require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CacheableClientsController do
  before(:each) do
    request.accept = "application/atom+xml"
  end
  
  context "requesting a single resource" do
    
    # it "should not set Etag" do
    #   get :single
    #   controller.response.etag.should == nil
    # end
    # 
    # it "sets Last-Modified with resource.updated_at" do
    #   get :single
    #   response.last_modified.should == Time.utc(2010)
    #   response.status.to_i.should == 200
    # end
    
    it "should return 304 Not Modified if client's cache is still valid" do
      request.env["HTTP_IF_MODIFIED_SINCE"] = Time.utc(2010).httpdate
      get :single
      response.status.to_i.should == 304
    end

    it "refreshes Last-Modified if cache is expired" do
          request.env["HTTP_IF_MODIFIED_SINCE"] = Time.utc(1999)
          get :single
          response.last_modified.should == Time.utc(2010)
          response.status.to_i.should == 200
        end
        
        it "does not set cache if Last-Modified is already in response" do
          get :single, :last_modified => true
          response.last_modified.should == Time.utc(2010, 2)
        end
      end
      
      context "collection" do
        it "sets Last-Modified using the most recent updated_at" do
          get :collection
          response.last_modified.should == Time.utc(2010)
          response.status.to_i.should == 200
        end
        
        it "works with empty array" do
          get :empty
          response.last_modified.should be_nil
          response.status.to_i.should == 200
        end
  end      

end
