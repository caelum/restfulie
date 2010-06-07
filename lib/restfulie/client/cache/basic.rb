# Basic cache implementation for restfulie.
#
# It uses the request headers and uri to store it in memory.
# This cache might not be optimal for long running clients, which should use a memcached based one.
# Use Restfulie::Client.cache_provider to change the provider
module Restfulie::Client::Cache
  class Basic

    def put(key, response)
      req = key[2]
      if Restfulie::Client::Cache::Restrictions.may_cache?(req, response)
        Restfulie::Common::Logger.logger.debug "caching #{url} #{req} #{response}"
        cache_add(key, req, response)
      end
      response
    end

    def get(key)

      puts "trying to get"
      response = cache_get(key, key[2])
      return nil if response.nil?

      if response.has_expired_cache?
        remove(key)
      else
        Restfulie::Common::Logger.logger.debug "RETURNING cache #{url} #{req}"
        cache_hit response
      end

    end
    
    # removes all elements from the cache
    def clear
      cache.clear
    end

  private

    # allows response enhancement when the cache was hit with it
    def cache_hit(response)
      response
    end

    def cache_add(key, req, response)
      if cache[key].nil?
        cache[key] = []
      end
      cache[key] << [req, response]
    end

    def cache_get(key, req)
      puts "trying to get"
      return nil if cache[key].nil?
      puts "trying to get"
      cache[key].each do |cached|
        puts "trying to get"
        old_req = cached.first
        puts "trying to get"
        old_response = cached.last
        puts "trying to get"
        return old_response if old_response.vary_headers_for(old_req) == old_response.vary_headers_for(req)
      end
      nil
    end

    def remove(what)
      @cache.delete(what)
      nil
    end

    def cache
      @cache ||= {}
    end

  end
end