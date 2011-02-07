module Restfulie
  module Client
    module Feature
      class FakeResponse
        attr_reader :code, :body
        def initialize(code, body)
          @code = code
          @body = body
        end
      end
    end
  end
end