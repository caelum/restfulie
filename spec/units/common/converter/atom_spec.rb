require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/models')

module Restfulie::Common::Converter::Test
  class SimpleClass
    attr_accessor :id, :title, :updated
    def initialize(id,title,updated)
      @id, @title, @updated = id, title, updated
    end
  end
end

describe Restfulie::Common::Converter do

  describe 'Atom' do

    describe 'default convertion' do

      it 'should convert string to atom representation' do

        s = %w(
          <?xml version="1.0" encoding="utf-8"?>
          <feed xmlns="http://www.w3.org/2005/Atom">
            <title>Example Feed</title>
            <link href="http://example.org/"/>
            <updated>2010-12-13T18:30:02Z</updated>
            <author>
              <name>John Doe</name>
            </author>
            <id>urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6</id>
            <entry>
              <title>Atom-Powered Robots Run Amok</title>
              <link href="http://example.org/2003/12/13/atom03"/>
              <id>urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a</id>
              <updated>2003-12-25T18:30:02Z</updated>
              <summary>Some text.</summary>
            </entry>
          </feed> ).join(" ")

        feed = Restfulie::Common::Converter::Atom.to_atom(s)
        feed.title.should == 'Example Feed'
        feed.links.first.href.should == 'http://example.org/'
        feed.updated.year.should == 2010
        feed.authors.first.name.should == 'John Doe'
        feed.id.should == 'urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6'

        entry = feed.entries.first
        entry.title.should == 'Atom-Powered Robots Run Amok'
        entry.links.first.href.should == 'http://example.org/2003/12/13/atom03'
        entry.id.should == 'urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a'
        entry.updated.day.should == 25
        entry.summary.should == 'Some text.'

        hash = Restfulie::Common::Converter::Atom.to_hash(s)
        hash["feed"]["title"].should == 'Example Feed'
        hash["feed"]["link"]["href"].should == 'http://example.org/'
        hash["feed"]["entry"]["title"].should == 'Atom-Powered Robots Run Amok'
      end

      it 'should convert simple class to atom representation' do
        obj = Restfulie::Common::Converter::Test::SimpleClass.new('id','title',DateTime.parse(DateTime.now.to_s))
        feed = Restfulie::Common::Converter::Atom.to_atom(obj)
        feed.id.should == obj.id
        feed.title.should == obj.title
        feed.updated.year.should == obj.updated.year
      end

      it "should convert feed in hash" do
        feed = Atom::Feed.new
        feed.id = 'urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6'
        feed.title = "Example Feed"

        hash = Restfulie::Common::Converter::Atom.to_hash(feed)
        hash["feed"]["id"].should == 'urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6'
        hash["feed"]["title"].should == 'Example Feed'
      end

      it "should convert entry in string" do
        entry = Atom::Entry.new
        entry.id = 'urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6'
        entry.title = "Example Entry"

        string = Restfulie::Common::Converter::Atom.to_s(entry)
        entry_by_parser = Atom.load(string)
        entry_by_parser.id.should == entry.id
        entry_by_parser.title.should == entry.title
        entry_by_parser.updated.should == entry.updated
      end

    end

    describe 'Default Convertion' do
      describe "Entry" do
        it "should convert simple class object to atom representation" do
          obj = Restfulie::Common::Converter::Test::SimpleClass.new('id','title',DateTime.parse(DateTime.now.to_s))
          entry = Restfulie::Common::Converter::Atom.to_atom(obj)
          entry.id.should == obj.id
          entry.title.should == obj.title
          entry.updated.should == obj.updated
        end

        it "should convert ActiveRecord instance to atom representation" do
          obj = Album.create(:title => "Album")

          entry = Restfulie::Common::Converter::Atom.to_atom(obj)
          entry.id.should == obj.id
          entry.title.should == obj.title
          entry.updated.should == obj.updated_at
        end

        it "should convert simple object to entry attom" do
          obj = Object.new
          values = { :id => "uri:1212", :title => "Object title", :updated => DateTime.parse("2010-01-13T18:30:02Z")}

          entry = Restfulie::Common::Converter::Atom.to_atom(obj, :values => values)
          entry.id.should == values[:id]
          entry.title.should == values[:title]
          entry.updated.should == values[:updated]
        end
      end

      describe "Feed" do
        it "should convert array of the simple instance to atom represenation" do
          @time   = DateTime.parse("2010-01-13T18:30:02Z")
          @albums = [Album.create, Album.create]

          @albums.last.updated_at = @time
          feed = Restfulie::Common::Converter::Atom.to_atom(@albums, :values => { :id => "uri:1212" })
          feed.should be_kind_of(Atom::Feed)
          feed.id.should == "uri:1212"
          feed.title.should == "Albums feed"
          feed.updated.should == @albums.first.updated_at.to_datetime
        end
      end
    end

    describe 'Custom Convertion' do
      before do
        @obj = Restfulie::Common::Converter::Test::SimpleClass.new('id','title',DateTime.parse(DateTime.now.to_s))
      end

      it 'should convert simple class to atom representation' do
        Restfulie::Common::Converter::Atom.describe_recipe(:id_recipe) do |representation, obj|
          representation.id = obj.id
        end

        Restfulie::Common::Converter::Atom.describe_recipe(:title_recipe) do |representation, obj|
          representation.title = "#{obj.title}/#{obj.id}"
        end

        feed = Restfulie::Common::Converter::Atom.to_atom(@obj, :recipes => [:id_recipe, :title_recipe]) do |representation, obj|
          representation.links << Restfulie::Common::Converter::Atom.link(:href => 'http://localhost', :rel => :self)
        end

        feed.id.should == @obj.id
        feed.title.should == "#{@obj.title}/#{@obj.id}"
        feed.updated.year.should == @obj.updated.year
        link = feed.links.first
        link.href.should == 'http://localhost'
        link.rel.should == :self
      end

      it "should convert with recipe block" do
        feed = Restfulie::Common::Converter::Atom.to_atom(@obj) do |representation, obj|
          representation.id      = obj.id
          representation.title   = "#{obj.title}/#{obj.id}"
          representation.updated = obj.updated
          representation.links   << Restfulie::Common::Converter::Atom.link(:href => 'http://localhost', :rel => :self)
        end
        
        feed.id.should == @obj.id
        feed.title.should == "#{@obj.title}/#{@obj.id}"
        feed.updated.year.should == @obj.updated.year
        link = feed.links.first
        link.href.should == 'http://localhost'
        link.rel.should == :self
      end
      
    end

    describe "errors" do
      it "raiser error to invalid atom type" do
        lambda {
          obj = Object.new
          Restfulie::Common::Converter::Atom.to_atom(obj, :atom_type => :foo)
        }.should raise_error(Restfulie::Common::Error::ConverterError, "Undefined atom type foo")
      end

      it "raiser error from requerid attribute in string" do
        s = %w(
            <?xml version="1.0" encoding="utf-8"?>
            <feed xmlns="http://www.w3.org/2005/Atom">
              <title>Example Feed</title>
              <link href="http://example.org/"/>
              <updated>2010-12-13T18:30:02Z</updated>
            </feed> ).join(" ")
        lambda {
          Restfulie::Common::Converter::Atom.to_atom(s)
        }.should raise_error(Restfulie::Common::Error::ConverterError, "Undefined required value id from Atom::Feed")
      end

      it "raiser error from requerid attribute in recipe" do
        lambda {
          obj = Object.new
          Restfulie::Common::Converter::Atom.to_atom(obj) do |rep|
            rep.id = obj.object_id
            rep.title = nil
          end
        }.should raise_error(Restfulie::Common::Error::ConverterError, "Undefined required value title from Atom::Entry")
      end
    end

  end

  def to_atom(*args, &recipe)
    Restfulie::Common::Converter::Atom.to_atom(*args, &recipe)
  end

  def register_recipe(*args, &recipe)
    Restfulie::Common::Converter::Atom.register_recipe(*args, &recipe)
  end

end
