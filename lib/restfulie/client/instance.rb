module Restfulie
  module Client
    module Instance
      
      # list of possible states to access
      attr_accessor :_possible_states

      # which content-type generated this data
      attr_accessor :_came_from
      
    end
  end
end
