class Restfulie::Common::Builder::Marshalling::Base
  def initialize(*args)
  end
  
  def builder_member(options = {})
    "#{self.class.to_s.demodulize} Marshalling not implemented"
  end
  
  def builder_collection(options = {})
    "#{self.class.to_s.demodulize} Marshalling not implemented"
  end
end