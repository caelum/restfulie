require 'net/http'
require 'uri'

require 'rubygems'
require 'active_support'
require 'action_controller'
require 'tokamak'

module Restfulie
  
  # Code common to both client and server side is contained in the common module.
  module Common
    autoload :Error, 'restfulie/common/error'
    autoload :Links, 'restfulie/common/links'
    autoload :Logger, 'restfulie/common/logger'
    autoload :Converter, 'restfulie/common/converter'
  end

  def self.extract_link_header(links)
    links.collect {|link| "<#{link.href}>; rel=#{link.rel}"}.join(', ')
  end
end

module Medie
  class Link
    def follow
      r = Restfulie.at(href)
      r = r.as(content_type) if content_type
      r
    end
  end
end

require 'restfulie/common/core_ext'
