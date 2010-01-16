require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class ClientRestfulieModel
  attr_accessor :content
  uses_restfulie
end

class ClientOrder
  attr_accessor :buyer
  uses_restfulie
end

context "accepts client unmarshalling" do

  context "when adding states" do
  
    it "should ignore namespaces" do
      xml = '<?xml version="1.0" encoding="UTF-8"?><client-restfulie-model xmlns="http://www.caelumobjects.com/restfulie"></client-restfulie-model>'
      model = ClientRestfulieModel.from_xml xml
      model.should_not eql(nil)
    end
  
    it "should be able to answer to the method rel name" do
      xml = '<?xml version="1.0" encoding="UTF-8"?><client-restfulie-model>  <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="pay" href="http://url_for/action_name"/><atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="next_state" href="http://url_for/action_name"/></client-restfulie-model>'
      model = ClientRestfulieModel.from_xml xml
      model.respond_to?('pay').should == true
    end
  
    it "should be able to answer to just one state change" do
      xml = '<?xml version="1.0" encoding="UTF-8"?><client-restfulie-model>  <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="cancel" href="http://url_for/action_name"/></client-restfulie-model>'
      model = ClientRestfulieModel.from_xml xml
      model.respond_to?('cancel').should == true
    end
  
  end  

end