class RenderController < ApplicationController
  include Restfulie::Server::ActionController::Base

  def index
    render :atom => [AtomifiedModel.new, AtomifiedModel.new, AtomifiedModel.new]
  end
  
  def show
    render :atom => AtomifiedModel.new
  end
  
  def show_with_mock
    render :atom => object
  end
end
