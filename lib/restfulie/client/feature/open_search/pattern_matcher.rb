module Restfulie::Client::Feature::OpenSearch
  
  class PatternMatcher

    def match(params, pattern)
      params = params.collect do |key, value|
        [key, value]
      end
      pattern = params.inject(pattern) do |pattern, p|
        what = "{#{p[0]}}"
        if pattern[what]
          pattern[what]= "#{p[1]}"
        end
        what = "{#{p[0]}?}"
        if pattern[what]
          pattern[what]= "#{p[1]}"
        end
        pattern
      end
      pattern.gsub(/\{[^\?]*\?\}/,"")
    end

  end

end
