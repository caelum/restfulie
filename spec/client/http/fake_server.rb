require 'rubygems'
require 'sinatra'

get "/test/?" do
  'OK'
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

