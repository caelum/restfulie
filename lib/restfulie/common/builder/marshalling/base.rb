class Restfulie::Builder::Marshalling::Base
  def initialize(*args)
  end
  
  def builder_member(options = {})
    "#{self.class.to_s.demodulize} Marshalling not impemented"
  end
  
  def builder_collection(options = {})
    "#{self.class.to_s.demodulize} Marshalling not impemented"
  end
end