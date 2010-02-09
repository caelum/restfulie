#
#  Copyright (c) 2009 Caelum - www.caelum.com.br/opensource
#  All rights reserved.
# 
#  Licensed under the Apache License, Version 2.0 (the "License"); 
#  you may not use this file except in compliance with the License. 
#  You may obtain a copy of the License at 
#  
#   http://www.apache.org/licenses/LICENSE-2.0 
#  
#  Unless required by applicable law or agreed to in writing, software 
#  distributed under the License is distributed on an "AS IS" BASIS, 
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
#  See the License for the specific language governing permissions and 
#  limitations under the License. 
#

# Basic cache implementation for restfulie.
#
# It uses the request headers and uri to store it in memory.
# This cache might not be optimal for long running clients, which should use a memcached based one.
# Use Restfulie::Client::Base.cache_provider to change the provider
module Restfulie
  module Client
    module Cache
      class Basic

        def put(url, req, response)
          if Restfulie::Client::Cache::Restrictions.may_cache?(req, response)
            Restfulie::Logger.logger.debug "caching #{url} #{req} #{response}"
            cache[key_for(url, req)] = response
          end
          response
        end

        def get(url, req)

          response = cache[key_for(url, req)]
          return nil if response.nil?

          if response.has_expired_cache?
            remove(key_for(url, req))
          else
            Restfulie::Logger.logger.debug "RETURNING cache #{url} #{req}"
            response
          end

        end

        # removes all elements from the cache
        def clear
          cache.clear
        end

        private

        def remove(what)
          @cache.delete(what)
          nil
        end

        def cache
          @cache ||= {}
        end

        def key_for(url, req)
          [url, req.class]
        end

      end
    end
  end
end