# Adds support to retrying a request if the result is 503.
#
# To use it, load it in your dsl:
# Restfulie.at("http://localhost:3000/product/2").retry_when_unavailable.get
module Restfulie::Client::Feature
  class RetryWhenUnavailable

  	def execute(chain, request, env)
  		resp = chain.continue(request, env)
  		if should_retry?(resp, env)
  			resp = chain.continue(request, env)
  		end
  		resp
  	end
  	
  	protected 
    # extension point that allows you to redefine
    # when a request should be retried
    def should_retry?(response, env)
      response.code.to_i == 503
    end
  	
  end
end

