require 'rubygems'
require 'sinatra'
require 'rack/conneg'

require File.join(File.dirname(__FILE__),'..','lib','data_helper')

use(Rack::Conneg) do |conneg|
  conneg.set :accept_all_extensions, false
  conneg.set :fallback, :html
  conneg.ignore('/public/')
  conneg.provide([:atom,:xml])
end

before do
  content_type negotiated_type
end

get "/test/?" do
  'OK'
end

post "/test/redirect/:location" do
  r = Rack::Response.new('OK', 201)
  r.header["Location"] = "#{request.scheme}://#{request.host}:#{request.port}/#{params[:location]}"
  r.finish
end

post "/test/?" do
  Rack::Response.new('OK', 201).finish
end

put "/test/?" do
  'OK'
end

delete "/test/?" do
  'OK'
end

get "/test/:error" do
  Rack::Response.new('OK', params[:error].to_i).finish
end

get '/:file_name' do
  respond_to do |wants|
    wants.atom { response_data( 'atoms', params[:file_name] ) } 
    wants.xml { response_data( 'atoms', params[:file_name] ) } 
    wants.html { response_data( 'atoms', params[:file_name] ) } 
  end
end

