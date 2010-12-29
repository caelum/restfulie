require 'spec_helper'

describe Restfulie::Common::Error do
  describe Restfulie::Common::Error::RestfulieError do
    it "RestfulieError should have StandardError as ancestors class" do
      msg = "Restfulie Error test"
      Restfulie::Common::Error::RestfulieError.ancestors.should be_include StandardError
      lambda {
        raise Restfulie::Common::Error::RestfulieError.new(msg)
      }.should raise_error(Restfulie::Common::Error::RestfulieError, msg)
    end
  end

  describe Restfulie::Common::Error::MarshallingError do
    it "MarshallingError should have RestfulieError as ancestors class" do
      msg = "Restfulie Marshalling Error test"
      Restfulie::Common::Error::MarshallingError.ancestors.should be_include Restfulie::Common::Error::RestfulieError
      lambda {
        raise Restfulie::Common::Error::MarshallingError.new(msg)
      }.should raise_error(Restfulie::Common::Error::MarshallingError, msg)
    end
  end

  describe Restfulie::Common::Error::UndefinedMarshallingError do
    it "UndefinedMarshallingError should have MarshallingError as ancestors class" do
      msg = "Restfulie Marshalling Error test"
      Restfulie::Common::Error::UndefinedMarshallingError.ancestors.should be_include Restfulie::Common::Error::MarshallingError
      lambda {
        raise Restfulie::Common::Error::UndefinedMarshallingError.new(msg)
      }.should raise_error(Restfulie::Common::Error::UndefinedMarshallingError, msg)
    end
  end
end