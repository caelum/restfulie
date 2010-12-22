module Restfulie::Client::Feature
  class EnhanceResponse
    def execute(flow, request, env)
      resp = flow.continue(request, env)
      unless resp.kind_of? ::Restfulie::Client::HTTP::ResponseHolder
        resp.extend(::Restfulie::Client::HTTP::ResponseHolder)
        resp.results_from request, resp
      end
      resp
    end
  end
end