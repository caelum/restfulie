require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

context Restfulie do

  it "should re-initiate entire request context when invoking Restfulie.at" do
    Restfulie.at('http://guilhermesilveira.wordpress.com/').should_not == (Restfulie.at('http://guilhermesilveira.wordpress.com/'))
  end

end