require 'rubygems'
require 'restfulie'
require 'client/buying_process.rb'

class Restfulie::Client::Cache::Basic
  def cache_hit(response)
    puts "Saving your time and money: cache hit!"
    response
  end
end

require 'spec_helper'

describe ItemsController do
  
  context "when creating an item" do

    it "should keep its values" do
      BuyingProcess.run
    end

  end
  
end
