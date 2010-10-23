module Restfulie::Client::Feature
  module OpenSearch
    autoload :PatternMatcher, 'restfulie/client/feature/open_search/pattern_matcher'
  end
end


module Restfulie::Client::Feature::OpenSearch
  
  def search(params)
    at PatternMatcher.new.match(params, params_pattern)
    get
  end
  
  attr_reader :params_pattern

  def with_pattern(params_pattern)
    @params_pattern = params_pattern
    self
  end

end
