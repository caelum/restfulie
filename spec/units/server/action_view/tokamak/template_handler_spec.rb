require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../../lib/models')
require File.expand_path(File.dirname(__FILE__) + '/../../../lib/routes')

class AlbumsController < ApplicationController
  def index
    @albums = Album.all
  end
  
  def show
    @album  = Album.find(params[:id])
  end
end

describe AlbumsController, :type => :controller do
  integrate_views
  
  describe "get index" do
    before do
      request.accept = "application/atom+xml"
      get :index, :format => :atom
      @feed = Restfulie::Common::Representation::Atom::Factory.create(response.body)
    end
    
    it "generation atom feed to get index" do
      @feed.entries.size.should == Album.count
    end
    
    it "title feed personalize" do
      @feed.title.should == "Index Album feed spec"
    end
    
    it "members artists transitions included" do
      transitions = @feed.entries.first.links
      transitions.find {|t| t.rel == 'artists'}.should be_kind_of(::Restfulie::Common::Representation::Atom::Link)
    end
  end # describe "get index"
  
  describe "get show" do
    before do
      request.accept = "application/atom+xml"
      @album = Album.first
      get :show, :id => @album.id, :format => :atom
      @entry = Restfulie::Common::Representation::Atom::Factory.create(response.body)      
    end
  
    it "generation atom entry" do
      @entry.title.should == @album.title
    end
  
    it "return extension values" do
      @entry.doc.at_xpath("albums:length_in_minutes", "albums" => "http://localhost/albums").content.to_i.should == @album.length
      @entry.doc.at_xpath("albums:description", "albums" => "http://localhost/albums").content.should == @album.description
    end
  end # describe "get show"
end
