require 'rubygems'
require  'ruby-debug' 
require 'restfulie'
require 'client/buying_process.rb'

class Restfulie::Client::Cache::Basic
  def cache_hit(response)
    puts "Saving your time and money: cache hit!"
    response
  end
end

BuyingProcess.run
