require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Restfulie::Common::Representation::Atom do

  it "validate atom" do
    full_atom = IO.read(File.dirname(__FILE__) + '/../../lib/atoms/full_atom.xml')
    atom = Restfulie::Common::Representation::Atom.new(full_atom)
    atom.valid?.should == true
    atom.errors.should == []
  end
end
