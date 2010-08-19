require 'rubygems'
require 'sinatra'
require 'rack/conneg'
require 'active_support'
require 'json'

require File.join(File.dirname(__FILE__),'..','support','data_helper')

use(Rack::Conneg) do |conneg|
  conneg.set :accept_all_extensions, false
  conneg.set :fallback, :html
  conneg.ignore('/public/')
  conneg.provide([:atom,:xml])
end

before do
  content_type negotiated_type
end

get "/favicon" do
  Rack::Response.new('OK', 200).finish
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

get "/request_with_querystring" do
  params.to_json
end

get '/test_redirection' do
  r = Rack::Response.new('', 201)
  r.header["Location"] = "http://localhost:4567/redirected"
  r.finish
end

get '/redirected' do
  "OK"
end

post '/custom/songs' do
  r = Rack::Response.new('', 201)
  r.header["Location"] = "http://localhost:4567/songs"
  r.finish
end

post '/with_content' do
  r = Rack::Response.new('<?xml version="1.0" encoding="UTF-8"?>
  <feed xmlns="http://www.w3.org/2005/Atom">
    <id>http://localhost:3000/</id>
    <title>NilClasses feed</title>
    <updated>2010-04-06T22:06:43-03:00</updated>
    <link href="http://localhost:3000/search_items" rel="search" type="application/atom+xml"/>
  </feed>
  ', 200)
  r.header["Content-type"] = "application/atom+xml"
  r.finish
end

get '/html_result' do
  respond_to do |wants|
    wants.html { Rack::Response.new('OK', 200).finish }
  end
end

get '/:file_name' do
  respond_to do |wants|
    wants.atom { response_data( 'atoms', params[:file_name] ) } 
    wants.xml { response_data( 'atoms', params[:file_name] ) } 
    wants.html { response_data( 'atoms', params[:file_name] ) } 
  end
end
