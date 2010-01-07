require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Client::HTTPResponse do
  
  def check_complies_with(from, to, method)
    o = Hashi::CustomHash.new
    o.extend Restfulie::Client::HTTPResponse
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