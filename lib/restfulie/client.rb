require 'net/http'
require 'uri'
require 'jeokkarak'
require 'hashi'

require 'restfulie/client/base'
require 'restfulie/client/entry_point'
require 'restfulie/client/helper'
require 'restfulie/client/instance'

module Restfulie
  def uses_restfulie
    extend Restfulie::Client::Base
    include Restfulie::Client::Instance
  end
end

Object.extend Restfulie

require 'restfulie/unmarshalling'
require 'restfulie/conversions'
class Hash
  include ActiveSupport::CoreExtensions::Hash::Conversions
end
