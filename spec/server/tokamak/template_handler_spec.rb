require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/models')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/routes')

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
      get :index, :format => :atom
      @feed = ::Atom::Feed.load_feed(response.body)
    end
    
    it "generation atom feed to get index" do
      @feed.entries.size.should == Album.count
    end
    
    it "title feed personalize" do
      @feed.title.should == "Index Album feed spec"
    end
    
    it "members artistis transitions included" do
      transitions = @feed.entries.first.links
      transitions.find {|t| t.rel == 'artistis'}.should be_kind_of(::Atom::Link)
    end
  end # describe "get index"
  
  describe "get show" do
    before do
      @album = Album.first
      get :show, :id => @album.id, :format => :atom
      @entry = ::Atom::Entry.load_entry(response.body)      
    end

    it "generation atom entry" do
      @entry.title.should == @album.title
    end

    it "return eagerload values" do
      @entry.album_length.to_i.should == @album.length
      @entry.album_description.should == @album.description
      @entry.album_length_in_minutes.should ==  "#{@album.length}m"
    end
  end # describe "get show"
end
