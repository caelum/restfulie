require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Restfulie::Common::Representation::Atom do
  before :all do
    full_atom = IO.read(File.dirname(__FILE__) + '/../../lib/atoms/full_atom.xml')
    @atom = Restfulie::Common::Representation::Atom.new(full_atom)
  end

  it "validate atom" do
    @atom.valid?.should == true
    @atom.errors.should == []
  end
  
  it "should access simple attributes" do
    @atom.id.should == "http://example.com/albums/1"
    @atom.title.should == "Albums feed"
    @atom.updated.should be_kind_of(Time)
    @atom.updated.should == Time.parse("2010-05-03T16:29:26-03:00")
  end
  
  it "should access author attributes" do
    @atom.authors.size.should == 2
    @atom.authors.first.name.should == "John Doe"
    @atom.authors.first.email.should == "joedoe@example.com"
  end
end
