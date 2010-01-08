require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'restfulie/server/opensearch'

context Restfulie::OpenSearch::Description do
  
  it "should describe the open search" do
    expected = '<?xml version="1.0" encoding="UTF-8"?>
     <OpenSearchDescription xmlns="http://a9.com/-/spec/opensearch/1.1/">
       <ShortName>System search</ShortName>
       <Description>System search</Description>
       <Url type="application/atom+xml" 
            template="http://example.com/?q={searchTerms}&amp;pw={startPage?}"/>
     </OpenSearchDescription>'
    xml = Restfulie::OpenSearch::Description.new("System search").accepts("application/atom+xml").to_xml
    #     xml.should eql(expected)
  end
  
end
