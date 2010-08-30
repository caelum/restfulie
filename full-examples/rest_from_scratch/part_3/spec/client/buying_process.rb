class BuyingProcess < Restfulie::Client::Mikyung::RestProcessModel
  at "http://localhost:3000/items"
  accept "application/xml"
  current_dir File.dirname(__FILE__)

  def initialize(*what)
    @what = what
  end
  
  def completed?(resource)
    resource.keys.first == "payment"
  end

  def self.run
    Restfulie::Common::Logger.logger.level = Logger::ERROR
    goal = BuyingProcess.new("Rest", "Calpis")
    result = Restfulie::Mikyung.new.achieve(goal).run
    result.response.code.should == 200
    result.payment.price.should == "410.0"
    puts "Goal Achieved"
  end
end
