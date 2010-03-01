# Copyright (c) 2008 The Kaphan Foundation
#
# For licensing information see LICENSE.txt.
#
# Please visit http://www.peerworks.org/contact for further information.
#

module Atom
  class Configuration
    def self.auth_hmac_enabled?
      unless defined?(@auth_hmac_enabled)
        begin
          gem 'auth-hmac'
          require 'auth-hmac'
          @auth_hmac_enabled = true
        rescue
          @auth_hmac_enabled = false
        end
      else
        @auth_hmac_enabled
      end
    end
  end
end
