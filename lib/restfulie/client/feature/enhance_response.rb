module Restfulie::Client::Feature
  class EnhanceResponse
    def execute(flow, request, response, env)
      resp = flow.continue(flow, request, response)
      unless resp.kind_of? ::Restfulie::Client::HTTP::ResponseHolder
        resp.extend(::Restfulie::Client::HTTP::ResponseHolder)
        resp.response = response
      end
      resp
    end
  end
end