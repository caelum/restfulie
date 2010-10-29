module Restfulie::Client::Cache
  module Restrictions
    class << self

      # checks whether this request verb and its cache headers allow caching
      def may_cache?(response)
        response && response.may_cache?
      end

    end

  end
end