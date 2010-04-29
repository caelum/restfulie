require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

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
      end

    end

    describe 'Custom Convertion' do
      before do
        @obj = Restfulie::Common::Converter::Test::SimpleClass.new('id','title',DateTime.parse(DateTime.now.to_s))
      end

      it 'should convert simple class to atom representation' do
        Restfulie::Common::Converter::Atom.describe_recipe(:simple_recipe) do |representation, obj|
          representation.id      = obj.id
          representation.title   = "#{obj.title}/#{obj.id}"
          representation.updated = obj.updated
          representation.links   << Restfulie::Common::Converter::Atom.link(:href => 'http://localhost', :rel => :self)
        end

        feed = Restfulie::Common::Converter::Atom.to_atom(@obj, :simple_recipe)
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
          Restfulie::Common::Converter::Atom.to_atom(obj, nil, :foo)
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
          end
        }.should raise_error(Restfulie::Common::Error::ConverterError, "Undefined required value title from Atom::Entry")
      end
    end

  end

end
