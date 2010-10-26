class Restfulie::Client::Feature::Cache
  
  def execute(flow, request, response, env)
    Restfulie::Client.cache_provider.get([request.host, request.path], request)
    resp = flow.continue(request, response, env)
    unless resp.kind_of? Exception
      Restfulie::Client.cache_provider.put([request.host, request.path], request, response)
    end
  end
  
end
