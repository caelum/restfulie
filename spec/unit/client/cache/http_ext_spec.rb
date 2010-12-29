require 'spec_helper'

class HashResponse
  include Restfulie::Client::HTTP::ResponseStatus
  attr_accessor :code
end

describe Restfulie::Client::HTTP::ResponseStatus do
  
  def check_complies_with(from, to, method)
    o = HashResponse.new
    (from..to).each do |code|
      o.code = code
      o.send(method).should be_true
    end
    [from-1,to+1].each do |code|
      o.code = code
      o.send(method).should be_false
    end
  end
  
  it "should return successful for 200~299" do
    check_complies_with(200, 299, :is_successful?)
  end

  it "should return informational for 100~199" do
    check_complies_with(100, 199, :is_informational?)
  end

  it "should return redirection for 300~399" do
    check_complies_with(300, 399, :is_redirection?)
  end

  it "should return redirection for 400~499" do
    check_complies_with(400, 499, :is_client_error?)
  end

  it "should return redirection for 500~599" do
    check_complies_with(500, 599, :is_server_error?)
  end

end

describe Restfulie::Client::HTTP::ResponseStatus do
  
  before do
    @response = mock Net::HTTPResponse
    @response.stub(:verb).and_return(:get)
    @response.extend Restfulie::Client::HTTP::ResponseCacheCheck
  end

  context "while retrieving cache information" do
    
    it "should invoke may_ache_field with cache control" do
      response = Object.new
      controls = [:cache_headers]
      @response.should_receive(:headers).and_return('cache-control' => controls)
      @response.should_receive(:may_cache_field?).with(controls).and_return(response)
      @response.may_cache?.should == response
    end
    
    it "should not cache if Cache-Control is not available" do
      @response.may_cache_field?(nil).should be_false
    end

    it "should not cache if Cache-Control's max-age is not available" do
      @response.may_cache_field?('s-maxage=100000').should be_false
    end

    it "should cache if finds max-age" do
      @response.may_cache_field?('max-age=100000, please-store').should be_true
    end
  
    it "should not cache if Cache-Control's no-store is set" do
      @response.may_cache_field?('max-age=100000, no-store').should be_false
    end
  
    it "should use all headers if received more than one header" do
      @response.may_cache_field?(['max-age=100000', 'no-store']).should be_false
    end
  
    it "should extract max-age from start" do
      @response.value_for('max-age=100', /^max-age=(\d+)/).should == "max-age=100"
    end
  
    it "should extract max-age from the middle" do
      @response.value_for('a=b,max-age=100', /^max-age=(\d+)/).should == "max-age=100"
    end
  
    it "should extract max-age from the middle even with whitespace" do
      @response.value_for('a=b, max-age=100', /^max-age=(\d+)/).should == " max-age=100"
    end
  
    it "should return nil if not found" do
      @response.value_for('a=b,s-max-age=100', /^max-age=(\d+)/).should be_nil
    end
  end
  
  context "when retrieving caching values" do
    
    it "should return 0 if the header value is not present" do
      @response.should_receive(:header_value_from).with('cache-control', /^\s*max-age=(\d+)/).and_return(nil)
      @response.cache_max_age.should == 0
    end
    
    it "should return the parsed value if the header value is not present" do
      @response.should_receive(:header_value_from).with('cache-control', /^\s*max-age=(\d+)/).and_return("57")
      @response.cache_max_age.should == 57
    end
    
    it "should return nothing if the header is not there" do
      field = Object.new
      @response.should_receive(:headers).and_return('header' => field)
      @response.should_receive(:value_for).with(field, 'expression').and_return(nil)
      @response.header_value_from('header','expression').should be_nil
    end
    
    it "should return the matching expression when extracting the header value" do
      field = Object.new
      @response.should_receive(:headers).and_return('header' => field)
      @response.should_receive(:value_for).with(field, /as(df)/).and_return("asdf")
      @response.header_value_from('header', /as(df)/).should == "df"
    end
    
  end
  
  context "when retrieving caching values" do
    it "should expire the response if there is no date" do
      @response.should_receive(:headers).and_return('date' => nil)
      @response.should be_has_expired_cache
    end

    it "should expire the response if its in the past with" do
      Time.should_receive(:now).and_return(201)
      Time.should_receive(:rfc2822).and_return(100)
      @response.should_receive(:cache_max_age).and_return(100)
      @response.stub(:headers).and_return('date' => [Object.new])
      @response.has_expired_cache?.should be_true
    end

    it "should expire the response if its in the future with" do
      Time.should_receive(:now).and_return(199)
      Time.should_receive(:rfc2822).and_return(100)
      @response.should_receive(:cache_max_age).and_return(100)
      @response.stub(:headers).and_return('date' => [Object.new])
      @response.has_expired_cache?.should be_false
    end

  end

  context "when checking response variants" do
    
    before do
      @request = mock Net::HTTPResponse
      @request.extend Restfulie::Client::HTTP::ResponseCacheCheck
    end
    
    it "should answer with the header from the request matching vary header" do
      @response.stub(:headers).and_return('vary' => 'accept')
      @request.stub(:[]).with('accept').and_return('application/xml')
      @response.vary_headers_for(@request).should == ['application/xml']
    end

    it "should answer with all headers from the request matching vary header" do
      @response.stub(:headers).and_return('vary' => 'accept, accept-language')
      @request.stub(:[]).with('accept').and_return('application/xml')
      @request.stub(:[]).with('accept-language').and_return('de')
      @response.vary_headers_for(@request).should == ['application/xml', 'de']
    end

    it "should answer with nil from the request matching vary header when non-existent" do
      @response.stub(:headers).and_return('vary' => 'accept, accept-language')
      @response.stub(:[]).with('vary').and_return('accept, accept-language')
      @request.stub(:[]).with('accept').and_return(nil)
      @request.stub(:[]).with('accept-language').and_return('de')
      @response.vary_headers_for(@request).should == [nil, 'de']
    end
    
    
  end

end