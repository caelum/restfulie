require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

context Restfulie do
    
  it "should work with twitter" do
    statuses = Restfulie.at("http://twitter.com/statuses/public_timeline.xml").get
    statuses.each do |status|
      puts "#{status.user.screen_name}: #{status.text}, #{status.created_at}"
    end
  end
  
end
