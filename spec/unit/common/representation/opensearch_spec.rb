require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Restfulie::Common::Representation::OpenSearch do
  
  it "should unmarshall opensearch xml descriptions" do
    xml = '<?xml version="1.0" encoding="UTF-8"?>
    <OpenSearchDescription xmlns="http://a9.com/-/spec/opensearch/1.1/">
      <ShortName>Restbuy</ShortName>
      <Description>Restbuy search engine.</Description>
      <Tags>restbuy</Tags>
      <Contact>admin@restbuy.com</Contact>
      <Url type="application/atom+xml"  template="http://localhost:3000/products?q={searchTerms}&amp;pw={startPage?}&amp;format=atom" />
    </OpenSearchDescription>'
    descriptor = Restfulie::Common::Representation::OpenSearch.new.unmarshal(xml)
    descriptor.urls.size.should == 1
    descriptor.use("application/atom+xml").host.should == URI.parse("http://localhost:3000/products")
    
    # Restfulie.at("http://localhost:3000/search.xml").get.resource.accepts("application/atom+xml").search(:searchTerms => "apple", :startPage => 2)
    
    
  end
  
end