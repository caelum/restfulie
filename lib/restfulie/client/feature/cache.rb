class Restfulie::Client::Feature::Cache
  
  def execute(flow, request, response, env)
    found = Restfulie::Client.cache_provider.get([request.host, request.path], request)
    return found if found
    
    resp = flow.continue(request, response, env)
    if resp.kind_of?(Exception)
      resp
    else
      Restfulie::Client.cache_provider.put([request.host, request.path], request, resp)
      resp
    end
  end
  
end
