module Restfulie
  module Common
    module Links
      def refresh
        links.self.follow.get
      end
    end
  end
end
