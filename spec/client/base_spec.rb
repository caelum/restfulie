require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class CustomType < ActiveRecord::Base
  uses_restfulie
end
class Item
end

context Restfulie::Client::Base do

  context "while checking for GET verbs that extract info" do

    it "should be self refreshers only in self retrieval" do
      Restfulie::Client::Base::SELF_RETRIEVAL.each do |key|
        CustomType.is_self_retrieval?(key).should be_true
      end
    end

    it "should be self refreshers only in self retrieval, but also strings" do
      Restfulie::Client::Base::SELF_RETRIEVAL.each do |key|
        CustomType.is_self_retrieval?(key.to_s).should be_true
      end
    end

  end

  
  context "while deserializing data from a response" do
    
    def prepare(code = "200")
      @origin = Object.new
      @res = mock Net::HTTPResponse
      @res.should_receive(:code).and_return(code)
    end

    it "should complain if its an unknown media type" do
      prepare
      @res.should_receive(:code).and_return('200')
      @res.should_receive(:content_type).at_least(1).and_return('vdr/unknown')
      lambda {CustomType.from_response @res, @origin}.should raise_error(Restfulie::Client::Base::UnsupportedContentType)
    end

    it "should return an empty hash if there is no body" do
      prepare
      @res.should_receive(:content_type).at_least(1).and_return('application/xml')
      @res.should_receive(:body).and_return('')
      result = CustomType.from_response @res, @origin
      result.should =={}
    end

    it "should return the xml parsed data if its there" do
      prepare
      expected = Object.new
      body = "<item></item>"

      @res.should_receive(:content_type).at_least(1).and_return('application/xml')
      @res.should_receive(:body).and_return(body)
      Item.should_receive(:from_xml).with(body).and_return(expected)
      result = CustomType.from_response @res, @origin
      result.should be_eql(expected)
    end

    it "should return the @original object if the response is 304" do
      prepare("304")
      CustomType.from_response(@res, @origin).should be_eql(@origin)
    end


  end

  # type = hash.keys[0].camelize.constantize
  # type.from_xml(@res.body)

end