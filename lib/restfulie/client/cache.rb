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
