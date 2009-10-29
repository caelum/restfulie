require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class RestfulieModel < ActiveRecord::Base
end

describe RestfulieModel do

  it "should be parsed to json" do
    lambda { subject.to_json }.should_not raise_error
  end
end
