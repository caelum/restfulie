class Restfulie::Builder::EntryRules < Restfulie::Builder::Rules
  
  def initialize(&block)
    yield(self)
  end
  
end