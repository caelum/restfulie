class CacheableClientsController < ApplicationController
  self.responder = Restfulie::Server::ActionController::RestfulResponder
  respond_to :json

  def single
    response.last_modified = Time.utc(2010, 2) if params[:last_modified]
    respond_with song_at(2010)
  end

  def collection
    respond_with [song_at(2010), song_at(2009)]
  end

  def new_record
    model = song_at(2010)
    model.new_record = true
    respond_with(model)
  end

  def empty
    respond_with []
  end
  
  private
  def song_at(year)
    Song.new(:created_at => Time.utc(year), :updated_at => Time.utc(year))
  end
end
