class Restfulie::Client::Feature::Cache
  
  def execute(flow, request, response, env)
    resp = flow.continue(request, response, env)
  end
  
end
