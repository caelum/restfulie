require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class City
  extend Restfulie::MediaTypeControl
  media_type 'application/vnd.caelum_city+xml'
end

context Restfulie::Server::AtomMediaType do
  
  before do
    @now = Time.now
  end
  
  context Array do

    it "should support atom feed media type by default" do
      Array.media_type_representations.include?('application/atom+xml').should be_true
    end
    
    it "should invoke atom feed creation with the block if its given" do
      controller = Object.new
      controller.stub(:url_for).and_return('uri')
      items = {'guilherme', 'silveira'}
      result = ['guilherme', 'silveira'].to_atom({:title=>"caelum", :controller => controller}) do |item|
        items.delete item
        item
      end
      items.should be_empty
      result.should include('guilherme')
      result.should include('silveira')
    end
    
  end
  
  context AtomFeed do
    
    it "should generate its own link" do
      uri = 'http://caelumobjects.com'
      controller = Object.new
      controller.should_receive(:url_for).with({}).and_return(uri)
      AtomFeed.new(nil).self_link(controller).should == "<link rel=\"self\" href=\"#{uri}\"/>"
    end

    it "array serialization to atom will serialize every element and allows id overriding" do
      expected = '<?xml version="1.0"?>
      <feed xmlns="http://www.w3.org/2005/Atom">
        <id>custom_id</id>
        <title type="text">Hotels list</title>
        <updated>' + @now.strftime('%Y-%m-%dT%H:%M:%S-08:00') + '</updated>
        <author><name>Hotels list</name></author>
        <link rel="self" href="http://caelumtravel.com/hotels"/>
        <items/>
      </feed>'
      first = City.new
      first.should_receive(:updated_at).and_return(@now)
      second = City.new
      second.should_receive(:updated_at).and_return(@now)

      controller = Object.new
      feed = AtomFeed.new([first, second]).id('custom_id')
      feed.should_receive(:items_to_atom_xml).and_return("<items/>")
      feed.should_receive(:self_link).with(controller).and_return("<link rel=\"self\" href=\"http://caelumtravel.com/hotels\"/>")
      feed.title('Hotels list').to_atom(controller).should == expected
    end

    it "array serialization to atom will use default id" do
      expected = '<?xml version="1.0"?>
      <feed xmlns="http://www.w3.org/2005/Atom">
        <id>http://caelumtravel.com/hotels</id>
        <title type="text">Hotels list</title>
        <updated>' + @now.strftime('%Y-%m-%dT%H:%M:%S-08:00') + '</updated>
        <author><name>Hotels list</name></author>
        <link rel="self" href="http://caelumtravel.com/hotels"/>
        <items/>
      </feed>'
      first = City.new
      first.should_receive(:updated_at).and_return(@now)
      second = City.new
      second.should_receive(:updated_at).and_return(@now)

      controller = Object.new
      controller.should_receive(:url_for).with({}).and_return('http://caelumtravel.com/hotels')
      feed = AtomFeed.new([first, second])
      feed.should_receive(:items_to_atom_xml).and_return("<items/>")
      feed.should_receive(:self_link).with(controller).and_return("<link rel=\"self\" href=\"http://caelumtravel.com/hotels\"/>")
      feed.title('Hotels list').to_atom(controller).should == expected
    end
    
    it "should serialize every item together" do
      first_entry = '<city>1</city>'
      second_entry = '<city>2</city>'
      first = City.new
      second = City.new
      controller = Object.new
      first.should_receive(:updated_at).and_return(@now)
      second.should_receive(:updated_at).and_return(@now)
      first.should_receive(:to_xml).with(:controller => controller, :skip_instruct=>true).and_return(first_entry)
      second.should_receive(:to_xml).with(:controller => controller, :skip_instruct=>true).and_return(second_entry)
      
      expected  = '          <entry>
            <id>http://caelumtravel.com/hotels/1</id>
            <title type="text">City</title>
            <updated>' + @now.strftime("%Y-%m-%dT%H:%M:%S-08:00") + '</updated>
            <link rel="self" href="http://caelumtravel.com/hotels/1"/>
            <content type="application/vnd.caelum_city+xml">
              ' + first_entry + '
            </content>
          </entry>
          <entry>
            <id>http://caelumtravel.com/hotels/2</id>
            <title type="text">City</title>
            <updated>' + @now.strftime("%Y-%m-%dT%H:%M:%S-08:00") + '</updated>
            <link rel="self" href="http://caelumtravel.com/hotels/2"/>
            <content type="application/vnd.caelum_city+xml">
              ' + second_entry + '
            </content>
          </entry>
'
        controller.should_receive(:url_for).with(first).and_return('http://caelumtravel.com/hotels/1')
        controller.should_receive(:url_for).with(second).and_return('http://caelumtravel.com/hotels/2')
        feed = AtomFeed.new([first, second])
        feed.should_receive(:self_link).with(controller, first).and_return("<link rel=\"self\" href=\"http://caelumtravel.com/hotels/1\"/>")
        feed.should_receive(:self_link).with(controller, second).and_return("<link rel=\"self\" href=\"http://caelumtravel.com/hotels/2\"/>")
        feed.items_to_atom_xml(controller, nil).should == expected
    end

    
    it "should serialize items invoking its block" do
      first = City.new
      controller = Object.new
      first.should_receive(:updated_at).and_return(@now)
      
      expected  = '          <entry>
            <id>http://caelumtravel.com/hotels/1</id>
            <title type="text">City</title>
            <updated>' + @now.strftime("%Y-%m-%dT%H:%M:%S-08:00") + '</updated>
            <link rel="self" href="http://caelumtravel.com/hotels/1"/>
            <content type="application/vnd.caelum_city+xml">
              <city>1</city>
            </content>
          </entry>
'

        controller.should_receive(:url_for).with(first).and_return('http://caelumtravel.com/hotels/1')
        feed = AtomFeed.new([first])
        feed.should_receive(:self_link).with(controller, first).and_return("<link rel=\"self\" href=\"http://caelumtravel.com/hotels/1\"/>")
        b = lambda{ |item| "<city>1</city>" }
        feed.items_to_atom_xml(controller, b).should == expected
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
      AtomFeed.new([]).updated_at.should == @now
    end
    
    it "should return now if the items dont answer to updated_at" do
      Time.should_receive(:now).and_return(@now)
      AtomFeed.new(["first", "second"]).updated_at.should == @now
    end
    
    it "should return a date in the future if an item has such date" do
      AtomFeed.new([Item.new(@now + 100)]).updated_at.should == @now+100
    end
    
    it "should return any date if there is any date" do
      AtomFeed.new([Item.new(@now - 100)]).updated_at.should == @now - 100
    end
    
    it "should return the most recent date if there is more than one date" do
      AtomFeed.new([Item.new(@now - 100), Item.new(@now-50)]).updated_at.should == @now - 50
    end
    
  end

end