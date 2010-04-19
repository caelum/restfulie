require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Hash do
  before do
    @hash = {"name" => "Guilherme Silveira", "link" => ["rel" => "start"]}
  end
  context "when requesting its links" do
    it "should return all links if there is more than one" do
      @hash["link"] << ["rel" => "end"]
      @hash.links.size.should == 2
    end
    it "should return the only link within an array" do
      @hash.links.size.should == 1
    end
    it "should return empty array if there are no links" do
      @hash.delete("link")
      @hash.links.should == []
    end
    it "should return the selected link if one is requested" do
      @hash.links("start").should be_kind_of(Restfulie::Client::Link)
    end
    it "should return nil if no link is available" do
      @hash.links("end").should be_nil
    end
  end
  context "when retrieving a value" do
    it "should return its value when invoking a method which key is contained" do
      @hash.name.should == "Guilherme Silveira"
    end
    it "should return true when respond_to? a key name" do
      @hash.respond_to?(:name).should be_true
      @hash.respond_to?("name").should be_true
    end
  end
end

context Restfulie::Common::Representation::Atom do
  
  context "when unmarshalling" do
    it "should unmarshall an entry" do
      result = Restfulie::Common::Representation::Atom.new.unmarshal('<entry xmlns="http://www.w3.org/2005/Atom" xmlns:items="http://localhost:3000/items" xmlns:payment="http://openbuy.com/payment" xmlns:item="http://openbuy.com/media/item">
         <title>http://localhost:3000/baskets/17/payments/17</title>
         <id>http://localhost:3000/baskets/17/payments/17</id>
         <updated>2010-04-08T20:31:33Z</updated>
         <payment:status>paid</payment:status>
       </entry>')
      result.should be_kind_of(Atom::Entry)
    end
  
    it "should unmarshall a feed" do
      result = Restfulie::Common::Representation::Atom.new.unmarshal('<?xml version="1.0" encoding="UTF-8"?>
      <feed xmlns="http://www.w3.org/2005/Atom" xmlns:basket="http://openbuy.com/basket">
        <id>http://localhost:3000/baskets/18</id>
        <title>http://localhost:3000/baskets/18</title>
        <updated>2010-04-08T20:41:10Z</updated>
        <link href="http://localhost:3000/baskets/18/payments" rel="payment" type="application/commerce+atom+xml"/>
        <entry xmlns:items="http://localhost:3000/items" xmlns:payment="http://openbuy.com/payment" xmlns:item="http://openbuy.com/media/item">
          <title>Entry about SelectedItem</title>
          <id>http://localhost:3000/items/35</id>
          <updated>2010-04-08T20:41:10Z</updated>
          <link href="http://localhost:3000/items/35" rel="self"/>
          <item:quantity>1</item:quantity>
        </entry>
        <entry xmlns:items="http://localhost:3000/items" xmlns:payment="http://openbuy.com/payment" xmlns:item="http://openbuy.com/media/item">
          <title>Entry about SelectedItem</title>
          <id>http://localhost:3000/items/36</id>
          <updated>2010-04-08T20:41:10Z</updated>
          <link href="http://localhost:3000/items/36" rel="self"/>
          <item:quantity>1</item:quantity>
        </entry>
        <basket:price>40.0</basket:price>
      </feed>'
      )
      result.should be_kind_of(Atom::Feed)
    end
    
  end
  
end