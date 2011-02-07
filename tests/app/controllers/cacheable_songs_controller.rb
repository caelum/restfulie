class CacheableClientsController < ApplicationController
  self.responder = Restfulie::Server::ActionController::RestfulResponder
  respond_to :json

  def single
    response.last_modified = Time.utc(2010, 2) if params[:last_modified]
    respond_with Song.new(:created_at => Time.utc(2010))
  end

  def collection
    respond_with [Song.new(:created_at => Time.utc(2010)), Song.new(:created_at => Time.utc(2009))]
  end

  def new_record
    model = Song.new(:created_at => Time.utc(2010))
    model.new_record = true
    respond_with(model)
  end

  def empty
    respond_with []
  end
end
