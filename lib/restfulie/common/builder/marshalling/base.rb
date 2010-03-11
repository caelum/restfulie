class Restfulie::Builder::Marshalling::Base
  class << self
    def builder_member(member, rule, options = {})
      "#{self.to_s.demodulize} Marshalling not impemented"
    end
    
    def builder_collection(collection, rule, options = {})
      "#{self.to_s.demodulize} Marshalling not impemented"
    end
  end
end