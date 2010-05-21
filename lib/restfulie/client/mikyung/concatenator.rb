class Restfulie::Client::Mikyung::Concatenator
  attr_reader :content
  def initialize(content, *args)
    @content = content
    args.each do |arg|
      @content << " " << arg.content
    end
  end
end
