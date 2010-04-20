require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Common::Representation::Atom do
  
  context "when unmarshalling" do
    it "should unmarshall an entry" do
      result = Restfulie::Common::Representation::Atom.unmarshal('<entry xmlns="http://www.w3.org/2005/Atom" xmlns:items="http://localhost:3000/items" xmlns:payment="http://openbuy.com/payment" xmlns:item="http://openbuy.com/media/item">
         <title>http://localhost:3000/baskets/17/payments/17</title>
         <id>http://localhost:3000/baskets/17/payments/17</id>
         <updated>2010-04-08T20:31:33Z</updated>
         <payment:status>paid</payment:status>
       </entry>')
      result.should be_kind_of(Atom::Entry)
    end
  
    it "should unmarshall a feed" do
      result = Restfulie::Common::Representation::Atom.unmarshal('<?xml version="1.0" encoding="UTF-8"?>
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
