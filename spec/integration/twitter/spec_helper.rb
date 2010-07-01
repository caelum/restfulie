$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'spec'
require 'restfulie'
require 'restfulie/client'
require 'fakeweb'

require File.dirname(__FILE__) + '/../fixtures/responses/twitter'

FakeWeb.allow_net_connect = false