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

  describe Restfulie::Error::SerializerError do
    it "SerializerError should have RestfulieError as ancestors class" do
      msg = "Restfulie Serializer Error test"
      Restfulie::Error::SerializerError.ancestors.should be_include Restfulie::Error::RestfulieError
      lambda {
        raise Restfulie::Error::SerializerError.new(msg)
      }.should raise_error(Restfulie::Error::SerializerError, msg)
    end
  end

  describe Restfulie::Error::UndefinedSerializerError do
    it "UndefinedSerializerError should have SerializerError as ancestors class" do
      msg = "Restfulie Serializer Error test"
      Restfulie::Error::UndefinedSerializerError.ancestors.should be_include Restfulie::Error::SerializerError
      lambda {
        raise Restfulie::Error::UndefinedSerializerError.new(msg)
      }.should raise_error(Restfulie::Error::UndefinedSerializerError, msg)
    end
  end
end