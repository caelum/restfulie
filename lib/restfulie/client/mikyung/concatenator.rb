module Restfulie
  module Client
    module Mikyung
      # Concatenates pure text in order to build messages
      # that are used as patterns.
      # Usage:
      # When there is a machine
      #
      # Will invoke concatenate 'machine' with 'a' with 'is' with 'there'
      class Concatenator
        attr_reader :content
        def initialize(content, *args)
          @content = args.inject(content) { |buf, arg| buf << " " << arg.content }
        end
      end
    end
  end
end
