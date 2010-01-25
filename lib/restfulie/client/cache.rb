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
    cache[key_for(url, req)]
  end
  
  private
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
        may_cache_method(request) && may_cache_cache_control(response.get_fields)
      end
      
      # only Post and Get requests are cacheable so far
      def may_cache_method(verb)
        verb==Net::HTTP::Post || verb==Net::HTTP::Get
      end
      
      # checks if the header's max-age is available and no no-store if available.
      def may_cache_cache_control(field)
        return false if field.nil?
        
        if field.kind_of? Array
          field.each do |f|
            return false if !may_cache_cache_control(f)
          end
          return true
        end

        max_age_header = value_for(field, /^max-age=(\d+)/)
        return false if max_age_header.nil?
        max_age = max_age_header[1]
        
        return false if value_for(field, /^no-store/)
        
        true
        
      end

      # extracts the header value for an specific expression, which can be located at the start or in the middle
      # of the expression
      def value_for(value, expression)
        value.split(",").find { |obj| obj.strip =~ expression }
      end
      
    end
    
  end
end
