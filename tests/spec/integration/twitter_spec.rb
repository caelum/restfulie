require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

context Restfulie do

  TWITTER_ENTRY_POINT = "http://twitter.com/statuses/public_timeline.xml"

  before do
    FakeWeb.allow_net_connect = false
    FakeWeb.register_uri(:get, TWITTER_ENTRY_POINT, :response => Responses::Twitter.public_timeline)
  end

  it "should work with twitter" do
    twitter = Restfulie.at(TWITTER_ENTRY_POINT).get
    twitter.statuses[0].user.screen_name.should == "fionnaps"
  end
  
  after do
    FakeWeb.allow_net_connect = true
  end

end