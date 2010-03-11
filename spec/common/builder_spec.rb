require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../data/data_helper')
require File.expand_path(File.dirname(__FILE__) + '/../lib/compare_atoms.rb')

ActionController::Routing::Routes.draw do |map|
  map.resources :albums do |album|
    album.resources :songs, :controller => 'albums/songs', :format => :xml
  end
  map.resources :songs
end

context "builder representations" do
  include Restfulie::Builder::Helpers

  context "marshalling atom" do
    context "for member" do
      before do
        dt     = DateTime.parse("2010-03-10T14:32:01-03:00")
        @album = Album.first
        @album.attributes = {:title => nil, :created_at => dt, :updated_at => dt, :length => 60, :description => "Album description"}
      end
      
      context "generate basic representation" do
        it "without eagerload" do 
          builder  = describe_member(@album, :eagerload => false)
          original_entry = Atom::Entry.load_entry(builder.to_atom)
          original_entry.should be_eql_xml(load_data("atoms/basic_member", "basic_member.xml"))
        end
        
        it "with eagerload values" do
          builder  = describe_member(@album, :eagerload => [:values])
          original_entry = Atom::Entry.load_entry(builder.to_atom)
          original_entry.should be_eql_xml(load_data("atoms/basic_member", "with_values.xml"))
        end
        
        it "with eagerload values and custom values" do
          builder  = describe_member(@album, :eagerload => [:values]) do |member|
            member.namespace(:album) do |ns|
              ns.composer = "Composer Name"
            end
          end

          original_entry = Atom::Entry.load_entry(builder.to_atom)
          original_entry.should be_eql_xml(load_data("atoms/basic_member", "with_values_and_custom_values.xml"))
        end
        
      end # context "generate basic representation"
      
    end # context "for member"

    context "for collection" do

    end # context "for member"
    
  end # context "marshalling atom"
end # context "marshalling representations"