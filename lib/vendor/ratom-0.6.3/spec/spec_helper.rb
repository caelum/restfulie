# Copyright (c) 2008 The Kaphan Foundation
#
# For licensing information see LICENSE.txt.
#
# Please visit http://www.peerworks.org/contact for further information.
#
begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'atom'

Spec::Runner.configure do |config|

  def mock_response(klass, body, headers = {})
    response = klass.new(nil, nil, nil)
    response.stub!(:body).and_return(body)
    
    headers.each do |k, v|
      response.stub!(:[]).with(k).and_return(v)
    end
    
    response
  end
  
  def mock_http_get(url, response, user = nil, pass = nil)
    req = mock('request')
    Net::HTTP::Get.should_receive(:new).with(url.request_uri).and_return(req)
    
    if user && pass
      req.should_receive(:basic_auth).with(user, pass)
    end
    
    http = mock('http')
    http.should_receive(:request).with(req).and_return(response)
    Net::HTTP.should_receive(:start).with(url.host, url.port).and_yield(http)
  end
end
