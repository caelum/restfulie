# Concatenates pure text in order to build messages
# that are used as patterns.
# Usage:
# When there is a machine
#
# Will invoke concatenate 'machine' with 'a' with 'is' with 'there'
class Restfulie::Client::Mikyung::Concatenator
  attr_reader :content
  def initialize(content, *args)
    @content = content
    args.each do |arg|
      @content << " " << arg.content
    end
  end
end
