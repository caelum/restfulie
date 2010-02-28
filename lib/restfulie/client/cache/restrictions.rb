module Restfulie::Client::Cache
  module Restrictions
    class << self

      # checks whether this request verb and its cache headers allow caching
      def may_cache?(request,response)
        may_cache_method?(request) && response.may_cache?
      end

      # only Post and Get requests are cacheable so far
      def may_cache_method?(verb)
        verb.kind_of?(Net::HTTP::Post) || verb.kind_of?(Net::HTTP::Get)
      end

    end

  end
end
