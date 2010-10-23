module Restfulie::Client::Feature::OpenSearch
  
  def search(params)
    get PatternMatcher.new.match(params, @params_pattern)
  end
  
  def with_pattern(params_pattern)
    @params_pattern = params_pattern
    self
  end

end

class PatternMatcher
  
  def match(params, pattern)
    
  end
  
end
