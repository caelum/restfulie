class Restfulie::BasicCache
  
  
  
end

# Fake cache that does not cache anything
class Restfulie::FakeCache
  
  def put(url, req)
  end
  
  def get(url, req)
  end
  
end

module Restfulie::Cache
  module Restrictions
    
    class << self
    
      def may_cache_method(verb)
        verb==Net::HTTP::Post || verb==Net::HTTP::Get
      end
      
    end
    
  end
end
