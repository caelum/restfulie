require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class City
  extend Restfulie::MediaTypeControl
  media_type 'application/vnd.caelum_city+xml'
end

context Restfulie::Server::AtomMediaType do
  
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
      <updated>2009-07-01T12:05:00Z</updated>
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
    first.should_receive(:to_xml).and_return(first_entry)
    second = City.new
    second.should_receive(:to_xml).and_return(second_entry)
    [first, second].to_atom.should eql(expected)
  end
  
  context "while checking the last modified date from an array" do
    
    class Item
      def initialize(time)
        @updated_at = time
      end
      attr_reader :updated_at
    end
    
    before do
      @now = Time.now
      Time.should_receive(:now).and_return(@now)
    end
    
    it "should return now if there are no items" do
      [].updated_at.should eql(@now)
    end
    
    it "should return now if the items dont answer to updated_at" do
      ["first", "second"].updated_at.should eql(@now)
    end
    
    it "should return a date in the future if an item has such date" do
      [Item.new(@now + 100)].updated_at.should eql(@now+100)
    end
    
  end
  
end