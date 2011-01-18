# ==== RequestHistory
# Uses RequestHistory to remind previous requests
#
# ==== Example:
#
#   result = Restfulie.at(uri).get
#   result = result.headers.links.payment.get
#   result.request_history(1) # doing first request
class Restfulie::Client::Feature::HistoryRequest

  def execute(flow, request, env)
    resp = flow.continue(request, env)
    request.make_snapshot(request)
    resp
  end
  
end
