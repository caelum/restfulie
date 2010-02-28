# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
end

class ApplicationController
  
  def self.inherit_restfulie
    # self.inherit_resources
    # self.extend Restfulie::Server::Controller
    # self.respond_to :xml, :html, :json
  end
  
end
