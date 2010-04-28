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

        s.extend(Restfulie::Common::Converter::Atom)

        feed = s.to_atom
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

      end

      it 'should convert simple class to atom representation' do
        obj = Restfulie::Common::Converter::Test::SimpleClass.new('id','title',DateTime.parse(DateTime.now.to_s))
        obj.extend(Restfulie::Common::Converter::Atom)
        feed = obj.to_atom
        feed.id.should == obj.id
        feed.title.should == obj.title
        feed.updated.year.should == obj.updated.year
      end

    end

    describe 'Custom Convertion' do

      before(:all) do
        Restfulie::Common::Converter::Atom.describe_recipe(:simple_recipe) do |representation, obj|
          representation.id      = obj.id
          representation.title   = "#{obj.title}/#{obj.id}"
          representation.updated = obj.updated
          representation.links   << Restfulie::Common::Converter::Atom.link(:href => 'http://localhost', :rel => :self)
        end        
      end

      it 'should convert simple class to atom representation' do
        obj = Restfulie::Common::Converter::Test::SimpleClass.new('id','title',DateTime.parse(DateTime.now.to_s))
        obj.extend(Restfulie::Common::Converter::Atom)

        feed = obj.to_atom(:simple_recipe)
        feed.id.should == obj.id
        feed.title.should == "#{obj.title}/#{obj.id}"
        feed.updated.year.should == obj.updated.year
        link = feed.links.first
        link.href.should == 'http://localhost'
        link.rel.should == :self

        feed = obj.to_atom
        feed.id.should == obj.id
        feed.title.should == obj.title
        feed.updated.year.should == obj.updated.year
        feed.links.size.should == 0
      end
      
    end

    describe "errors" do
      it "raiser error to invalid atom type" do
        lambda {
          obj = Object.new
          obj.extend(Restfulie::Common::Converter::Atom)
          obj.to_atom(nil, :foo)
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
          s.extend(Restfulie::Common::Converter::Atom)
          s.to_atom
        }.should raise_error(Restfulie::Common::Error::ConverterError, "Undefined required value id from Atom::Feed")
      end
    end

  end

end
