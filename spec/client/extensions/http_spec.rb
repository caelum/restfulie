require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Client::HTTPResponse do
  
  it "should return successful for 200~299" do
    o = Hashi::CustomHash.new
    o.extend Restfulie::Client::HTTPResponse
    (200..299).each do |code|
      o.code = code
      o.is_successful?.should be_true
    end
    [199,300].each do |code|
      o.code = code
      o.is_successful?.should be_false
    end
  end

end