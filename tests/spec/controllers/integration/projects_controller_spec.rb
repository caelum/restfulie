require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ProjectsController do

  render_views

  before do
    request.accept = "application/atom+xml"
    response.stub(:content_type) { "application/atom+xml" }
  end

  it "renders view files with tokamak extension" do
    request.accept = "application/atom+xml"
    get :index, :format => :atom
    response.body.should include("<title>index.atom.tokamak</title>")
    response.header["Link"].should == "<http://google.com>; rel=create, <http://google.com/test>; rel=show"
  end

  it "renders view files without explicit format" do
    request.accept = "application/atom+xml"
    get :show, :format => :atom
    response.body.should include("<title>show.tokamak</title>")
  end
  
  it "prefers views with explicit format" do
    request.accept = "application/atom+xml"
    get :new, :format => :atom
    response.body.should include("<title>new.atom.tokamak</title>")
  end
end