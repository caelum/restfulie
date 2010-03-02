require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

Restfulie::Marshalling.load_marshalling(:base)

context ::Restfulie::Marshalling::Base do
  it "should accept a block a argument" do
    @title = "Title test"
    marshalling = ::Restfulie::Marshalling::Base.new() { feed.title = @title; puts feed.title }
    marshalling.should be_kind_of(::Restfulie::Marshalling::Base)
  end
end