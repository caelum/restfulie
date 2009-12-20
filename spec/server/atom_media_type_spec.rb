require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class City
  extend Restfulie::MediaTypeControl
  media_type 'application/vnd.caelum_city+xml'
end

context Restfulie::Server::AtomMediaType do
  
  before do
    @now = Time.now
  end

  it "should support atom feed media type by default" do
    Array.media_type_representations.include?('application/atom+xml').should be_true
  end

  it "array serialization to atom will serialize every element" do
    first_entry = '<city>1</city>'
    second_entry = '<city>2</city>'
    expected = '<?xml version="1.0"?>
    <feed xmlns="http://www.w3.org/2005/Atom">
      <id>urn:uuid:d0b4f914-30e9-418c-8628-7d9b7815060f</id>
      <title type="text">Hotels list</title>
      <updated>' + @now.strftime('%Y-%m-%dT%H:%M:%S-08:00') + '</updated>
      <generator uri="http://caelumtravel.com">Hotels Service</generator>
      <link rel="self" href="http://caelumtravel.com/hotels"/>
      <entry>
        <id>urn:uuid:aa990d44-fce0-4823-a971-d23facc8d7c6</id>
        <title type="text">hotel</title>
        <updated>2009-07-01T11:58:00Z</updated>
        <author>
          <name>caelum travel</name>
        </author>
        <link rel="self" href="http://caelumtravel.com/hotels/1"/>
        <content type="application/vnd.hotel+xml">
          ' + first_entry + '
        </content>
      </entry>
      <entry>
        <id>urn:uuid:6fa8eca3-48ee-44a9-a899-37d047a3c5f2</id>
        <title type="text">order</title>
        <updated>2009-07-01T11:25:00Z</updated>
        <author>
          <name>caelum travel</name>
        </author>
        <link rel="self" href="http://caelumtravel.com/hotels/2"/>
        <content type="application/vnd.hotel+xml">
        ' + second_entry + '
        </content>
      </entry>
    </feed>'
    first = City.new
    first.should_receive(:updated_at).and_return(@now)
    first.should_receive(:to_xml).and_return(first_entry)
    second = City.new
    second.should_receive(:updated_at).and_return(@now)
    second.should_receive(:to_xml).and_return(second_entry)
    AtomFeed.new([first, second]).title('Hotels list').to_atom.should eql(expected)
  end
  
  context AtomFeed do
    
    it "should generate its own link" do
      uri = 'http://caelumobjects.com'
      controller = Object.new
      controller.should_receive(:url_for).with({}).and_return(uri)
      AtomFeed.new(nil).self_link(controller).should eql("<link rel=\"self\" href=\"#{uri}\"/>")
    end
    
  end
  
  context "while checking the last modified date from an array" do
    
    class Item
      def initialize(time)
        @updated_at = time
      end
      attr_reader :updated_at
    end
    
    it "should return now if there are no items" do
      Time.should_receive(:now).and_return(@now)
      AtomFeed.new([]).updated_at.should eql(@now)
    end
    
    it "should return now if the items dont answer to updated_at" do
      Time.should_receive(:now).and_return(@now)
      AtomFeed.new(["first", "second"]).updated_at.should eql(@now)
    end
    
    it "should return a date in the future if an item has such date" do
      AtomFeed.new([Item.new(@now + 100)]).updated_at.should eql(@now+100)
    end
    
    it "should return any date if there is any date" do
      AtomFeed.new([Item.new(@now - 100)]).updated_at.should eql(@now - 100)
    end
    
    it "should return the most recent date if there is more than one date" do
      AtomFeed.new([Item.new(@now - 100), Item.new(@now-50)]).updated_at.should eql(@now - 50)
    end
    
  end
  
end