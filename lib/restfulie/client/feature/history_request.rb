class Restfulie::Client::Feature::HistoryRequest

  def execute(flow, request, response, env)
    resp = flow.continue(request, response, env)
    request.make_snapshot(request)
    resp
  end
  
end
