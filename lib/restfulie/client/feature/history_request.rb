# ==== RequestHistory
# Uses RequestBuilder and remind previous requests
#
# ==== Example:
#
#   @executor = ::Restfulie::Client::HTTP::RequestHistoryExecutor.new("http://restfulie.com") #this class includes RequestHistory module.
#   @executor.at('/posts').as('application/xml').accepts('application/atom+xml').with('Accept-Language' => 'en').get.code #=> 200 #first request
#   @executor.at('/blogs').as('application/xml').accepts('application/atom+xml').with('Accept-Language' => 'en').get.code #=> 200 #second request
#   @executor.request_history!(0) #doing first request
#
class Restfulie::Client::Feature::HistoryRequest

  def execute(flow, request, response, env)
    resp = flow.continue(request, response, env)
    request.make_snapshot(request)
    resp
  end
  
end
