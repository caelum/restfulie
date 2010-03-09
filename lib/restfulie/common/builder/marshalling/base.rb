class Restfulie::Builder::Marshalling::Base
  attr_accessor :title

  def initialize(*args, &block)
    # yield(self) if block_given?
    self.instance_eval(&block) if block_given?
  end
  
  def feed
    self
  end
end