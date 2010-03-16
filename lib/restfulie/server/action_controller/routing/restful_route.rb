module Restfulie::Server::ActionController::Routing::Route

  def self.included(base)
    #base.alias_method_chain :extract_request_environment, :host
  end

  #def extract_request_environment_with_host(request)
    #env = extract_request_environment_without_host(request)
    #env.merge :host => request.host,
      #:domain => request.domain, :subdomain => request.subdomains.first
  #end
  
end

