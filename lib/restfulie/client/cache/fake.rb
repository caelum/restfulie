# Fake cache that does not cache anything
# Use Restfulie::Client.cache_provider = Restfulie::Client::Cache::Fake.new
module Restfulie::Client::Cache
  class Fake
    def put(url, req, response)
      response
    end

    def get(url, req)
    end

    def clear
    end
  end
end