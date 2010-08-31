class CacheableClientsController < ApplicationController
  self.responder = Restfulie::Server::ActionController::RestfulResponder
  # include Restfulie::Server::ActionController::Base
  respond_to :atom

  def single
    response.last_modified = Time.utc(2010, 2) if params[:last_modified]
    respond_with AtomifiedModel.new(Time.utc(2010))
  end

  def collection
    respond_with [AtomifiedModel.new(Time.utc(2010)), AtomifiedModel.new(Time.utc(2009))]
  end

  def new_record
    model = AtomifiedModel.new(Time.utc(2010))
    model.new_record = true
    respond_with(model)
  end

  def empty
    respond_with []
  end
end
