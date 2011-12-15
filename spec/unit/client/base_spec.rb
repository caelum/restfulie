require 'spec_helper'

describe Restfulie do

  it "should re-initiate entire request context when invoking Restfulie.at" do
    Restfulie.at('http://guilhermesilveira.wordpress.com/').should_not == (Restfulie.at('http://guilhermesilveira.wordpress.com/'))
  end

  it "should set headers when with options is given" do
    response = Restfulie.at('http://google.com').with({'Service-Ticket' => 'foobar'})
    response.headers.should == {'Service-Ticket' => 'foobar'}
  end

end
