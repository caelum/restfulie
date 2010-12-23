module Restfulie::Client::Cache
  
  # Cache restrictions that allow you to cache this response or not
  module Restrictions
    class << self

      # checks whether this request verb and its cache headers allow caching
      def may_cache?(response)
        response && response.may_cache?
      end

    end

  end
end