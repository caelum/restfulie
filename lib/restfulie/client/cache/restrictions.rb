module Restfulie::Client::Cache
  module Restrictions
    class << self

      # checks whether this request verb and its cache headers allow caching
      def may_cache?(response)
        response && may_cache_method?(response.method) && response.may_cache?
      end

      # only Post and Get requests are cacheable so far
      def may_cache_method?(verb)
        verb == :get || verb == :post
      end

    end

  end
end