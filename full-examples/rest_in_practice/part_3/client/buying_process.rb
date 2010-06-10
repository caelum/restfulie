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
    # Restfulie::Common::Logger.logger.level = Logger::DEBUG
    goal = BuyingProcess.new("Rest", "Calpis")
    result = Restfulie::Mikyung.new.achieve(goal).run
    puts "Goal Achieved"
    puts result.response.body
  end
end
