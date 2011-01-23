require 'spec_helper'

describe Restfulie do

  it "should re-initiate entire request context when invoking Restfulie.at" do
    puts "meu teste"
    puts Restfulie.at('http://guilhermesilveira.wordpress.com/').accepts("application/xml").get().headers()
    
  end

end