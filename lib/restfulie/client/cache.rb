# Basic cache implementation for restfulie.
#
# It uses the request headers and uri to store it in memory.
# This cache might not be optimal for long running clients, which should use a memcached based one.
# Use Restfulie.cache_provider to change the provider
class Restfulie::BasicCache
  
  def put(url, req, response)
    cache[key_for(url, req)] = response if Restfulie::Cache::Restrictions.may_cache(req, response)
    response
  end
  
  def get(url, req)
    response = cache[key_for(url, req)]
    return nil if response.nil?
    if response.has_expired_cache?
      remove(key_for(url, req))
      nil
    else
      response
    end
  end
  
  private
  
  def remove(what)
    @cache.delete(what)
  end
  
  def cache
    @cache ||= {}
  end
  
  def key_for(url, req)
    [url, req]
  end
  
end

# Fake cache that does not cache anything
# Use Restfulie.cache_provider = Restfulie::FakeCache.new
class Restfulie::FakeCache
  
  def put(url, req, response)
    response
  end
  
  def get(url, req)
  end
  
end

module Restfulie::Cache
  module Restrictions
    
    class << self
    
      # checks whether this request verb and its cache headers allow caching
      def may_cache(request,response)
        may_cache_method?(request) && response.may_cache?
      end
      
      # only Post and Get requests are cacheable so far
      def may_cache_method?(verb)
        verb==Net::HTTP::Post || verb==Net::HTTP::Get
      end

    end
    
  end
end
