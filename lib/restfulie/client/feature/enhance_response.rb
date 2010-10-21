module Restfulie::Client::Feature
  class EnhanceResponse
    def execute(flow, request, response, env)
      resp = flow.continue(request, response, env)
      unless resp.kind_of? ::Restfulie::Client::HTTP::ResponseHolder
        resp.extend(::Restfulie::Client::HTTP::ResponseHolder)
        resp.response = resp
      end
      resp
    end
  end
end