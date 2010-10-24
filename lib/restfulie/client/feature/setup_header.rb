module Restfulie::Client::Feature

  class SetupHeader
    
    def execute(flow, request, response, env)
      headers = request.default_headers.dup
      host = request.host
      if host.user || host.password
        headers["Authorization"] = "Basic " + ["#{host.user}:#{host.password}"].pack("m").delete("\r\n")
      end
      headers.delete :recipe
      headers['cookie'] = request.cookies if request.cookies
      
      # gs: this should not be overriden, do it in some other way
      request.headers = headers
      
      flow.continue(request, response, env)
    end
    
  end
  
end