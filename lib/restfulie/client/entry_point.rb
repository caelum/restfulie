module Restfulie
  module Client
    module Base
      
      def entry_point_for
        EntryPointControl.new(self)
      end
      
      def remote_create(content)
        
      end
      
    end
  end
end
class EntryPointControl
  def initialize(type)
    @type = type
    @entries = {}
  end
  def creation
    @entries[:creation] = EntryPoint.new unless @entries[:creation]
    @entries[:creation]
  end
  
end
class EntryPoint
  attr_accessor :uri
  def at(uri)
    @uri = uri
  end
end