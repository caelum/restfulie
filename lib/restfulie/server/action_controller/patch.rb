module ActionController::Routing
  HTTP_METHODS = [:get, :head, :post, :put, :delete, :options, :patch]
end

ActionController::Request::HTTP_METHODS << "patch"
ActionController::Request::HTTP_METHOD_LOOKUP["PATCH"] = :patch
