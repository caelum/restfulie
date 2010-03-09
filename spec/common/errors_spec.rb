require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Restfulie::Error do
  describe Restfulie::Error::RestfulieError do
    it "RestfulieError should have StandardError as ancestors class" do
      msg = "Restfulie Error test"
      Restfulie::Error::RestfulieError.ancestors.should be_include StandardError
      lambda {
        raise Restfulie::Error::RestfulieError.new(msg)
      }.should raise_error(Restfulie::Error::RestfulieError, msg)
    end
  end

  describe Restfulie::Error::MarshallingError do
    it "MarshallingError should have RestfulieError as ancestors class" do
      msg = "Restfulie Marshalling Error test"
      Restfulie::Error::MarshallingError.ancestors.should be_include Restfulie::Error::RestfulieError
      lambda {
        raise Restfulie::Error::MarshallingError.new(msg)
      }.should raise_error(Restfulie::Error::MarshallingError, msg)
    end
  end

  describe Restfulie::Error::UndefinedMarshallingError do
    it "UndefinedMarshallingError should have MarshallingError as ancestors class" do
      msg = "Restfulie Marshalling Error test"
      Restfulie::Error::UndefinedMarshallingError.ancestors.should be_include Restfulie::Error::MarshallingError
      lambda {
        raise Restfulie::Error::UndefinedMarshallingError.new(msg)
      }.should raise_error(Restfulie::Error::UndefinedMarshallingError, msg)
    end
  end
end