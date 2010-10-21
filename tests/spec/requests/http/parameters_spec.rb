require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

class Object
  def debug
    debugger
    self
  end
end

context Restfulie do
  
  it "should accept parameters in get requests" do
    result = Restfulie.at('http://localhost:4567/request_with_querystring').debug.get(:foo => "bar", :bar => "foo")
    params  = JSON.parse(result.body)
    params["foo"].should == "bar"
    params["bar"].should == "foo"
  end
  
end